class MineField
  attr_reader :fields, :difficulty

  BEGINNER_WIDTH, BEGINNER_HEIGHT, BEGINNER_MINES = 8, 8, 10
  INTERMEDIATE_WIDTH, INTERMEDIATE_HEIGHT, INTERMEDIATE_MINES = 16, 16, 40
  EXPERT_WIDTH, EXPERT_HEIGHT, EXPERT_MINES = 30, 16, 99

  def initialize(params={})
    params = { :difficulty => :beginner }.merge params
    @difficulty = params[:difficulty] || :beginner
    case @difficulty
    when :intermediate: @fields = create_fields(INTERMEDIATE_WIDTH, INTERMEDIATE_HEIGHT, INTERMEDIATE_MINES)
    when :expert: @fields = create_fields( EXPERT_WIDTH, EXPERT_HEIGHT, EXPERT_MINES)
    else @fields = create_fields(BEGINNER_WIDTH, BEGINNER_HEIGHT, BEGINNER_MINES)
    end
  end

  def create_fields(width, height, mines)
    fields = Array.new(width) { Array.new(height, false) }
    while(mines > 0) do
      x = rand(width)
      y = rand(height)
      unless (fields[x][y] == :mine)
        fields[x][y] = :mine
        mines -= 1
      end
    end
    fields
  end

  def adjacent_mines(x, y)
    return false if @fields[x][y] == :mine || @fields[x][y] == :boom
    coords = []
    coords << [x-1, y] << [x+1, y] << [x, y-1] << [x, y+1] << [x-1, y-1] << [x-1, y+1] << [x+1, y-1] << [x+1, y+1]
    # reject the coordinates that bleed over the edges of the playfield
    coords = coords.reject do |x, y|
      x < 0 || y < 0 || x > @fields.size - 1 || y > @fields[0].size - 1
    end
    mines = 0
    coords.each do |x, y|
      mines += 1 if @fields[x][y] == :mine || @fields[x][y] == :boom
    end
    mines
  end

  def uncover_field(x, y)
    field = adjacent_mines(x, y)
    if field
      @fields[x][y] = field
    else
      @fields[x][y] = :boom
    end
    field
  end
end
