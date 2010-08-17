require "rubygems"
require "shoulda"
require "test/unit"

require File.dirname(__FILE__) + "/../lib/minefield"

class TestMineField < Test::Unit::TestCase
  def setup
    @beginner = MineField.new(:difficulty => :beginner)
    @intermediate = MineField.new(:difficulty => :intermediate)
    @expert = MineField.new(:difficulty => :expert)
  end

  should "have the MineField class defined" do
    mines = MineField.new
  end

  should "have a readable attribute :difficulty" do
    assert(MineField.new.difficulty)
  end

  should "default difficulty to beginner" do
    assert_equal(:beginner, MineField.new.difficulty)
  end

  should "store difficulties correctly" do
    assert_equal(:beginner, MineField.new(:difficulty => :beginner).difficulty)
    assert_equal(:intermediate, MineField.new(:difficulty => :intermediate).difficulty)
    assert_equal(:expert, MineField.new(:difficulty => :expert).difficulty)
  end

  should "have the right amount of mines at the difficulty level" do
    assert_equal(10, count_mines(@beginner))
    assert_equal(40, count_mines(@intermediate))
    assert_equal(99, count_mines(@expert))
    assert_equal(30, @expert.fields.size)
    assert_equal(16, @expert.fields[0].size)
  end

  should "return false if the field is occupied by a mine" do
    @beginner.fields[0][0] = :mine
    assert_equal(:mine, @beginner.fields[0][0])
    assert_equal(false, @beginner.adjacent_mines(0, 0))
  end
  should "calculate adjacent mines for corner fields correctly" do
    @beginner.fields[0][0] = false
    @beginner.fields[0][1] = :mine
    @beginner.fields[1][0] = false
    @beginner.fields[1][1] = false
    @beginner.fields[7][0] = :mine
    assert_equal(1, @beginner.adjacent_mines(0, 0))
  end

  should "uncover a field" do
    @beginner.uncover_field(3, 4)
    puts ""
    @beginner.fields.each {|column| p column }
  end

  def count_mines(minefield)
    mines = 0
    minefield.fields.each do |x|
      x.each do |y|
        mines += 1 if y == :mine
      end
    end
    mines
  end

end
