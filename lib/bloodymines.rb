require File.dirname(__FILE__) + "/minefield"

class Bloodymines
  attr_reader :minefield, :width, :height
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

  def result
    score = 0
    finished = true
    @minefield.fields.each do |rows|
      rows.each do |cell|
        score += cell if cell.kind_of?(Integer)
        finished = false if cell == false || cell == :boom
      end
    end
    {:score => score, :finished => finished}
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
