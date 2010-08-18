require "minefield"

class Bloodymines
  attr_reader :minefield, :x_max, :y_max
  def initialize(params={})
    params = { :difficulty => :beginner }.merge params
    @minefield = MineField.new(:difficulty => params[:difficulty])
    @width = @minefield.fields.size
    @height = @minefield.fields[0].size
  end

  def uncover(x, y)
    @minefield.uncover_field(x, y)
  end

  def difficulty
    @minefield.difficulty
  end

  def score
    score = 0
    @minefield.fields.each do |rows|
      rows.each do |cell|
        score += cell if cell.kind_of?(Integer)
      end
    end
    score
  end

  # returns true if you triggered a mine or uncovered all save fields
  def ended?
    uncovered = 0
    @minefield.fields.each do |rows|
      rows.each do |cell|
        uncovered += 1 if cell == false
        return true if cell == :boom
      end
    end
    return false if uncovered > 0
    true
  end

end