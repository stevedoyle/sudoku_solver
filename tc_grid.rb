require 'test/unit'
require_relative 'grid'

class Grid
  attr_reader :cells
end

class TestGrid < Test::Unit::TestCase

  def setup
    @puzzle = "" \
      "*53**4***" \
      "***5914**" \
      "*2***6**1" \
      "89*7**634" \
      "*1*****9*" \
      "642**3*15" \
      "2**4***8*" \
      "**9368***" \
      "***1**94*"
    @grid = Grid.new(@puzzle)
  end
  
  def test_initialize
    assert_equal(5, @grid.get(0, 1))
  end
  
  def test_complete_1
    assert_equal(false, @grid.complete?)
  end
  
  def test_complete_2
    (0..8).each { |row| (0..8).each { |col| @grid.assign(row, col, 1) } }
    assert_equal(true, @grid.complete?)
  end
  
  def test_assign
    @grid.assign(0,0,1)
    assert_equal(1, @grid.get(0,0))
  end
  
  def test_solve
    assert_equal(true, @grid.solve, message="#{@grid}")
    assert_equal(true, @grid.valid?, message="#{@grid}")
  end
  
  def test_count_empty_cells
    assert_equal(@puzzle.count('*'), @grid.count_empty_cells)
  end
  
  def test_modified
    assert_equal(false, @grid.modified?)
    @grid.solve
    assert_equal(true, @grid.modified?)
    @grid.clear_modification_status
    assert_equal(false, @grid.modified?)
  end
  
end
