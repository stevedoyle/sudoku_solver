require 'test/unit'
require_relative 'cellGroup'
require_relative 'cell'

class TestCellGroup < Test::Unit::TestCase

  def setup
    @cells = Array.new(9) { Cell.new }
    @group = CellGroup.new(@cells)
  end
  
  def test_initialize
    assert_equal(false, @group.complete?)
  end
  
  def test_complete
    assert_equal(false, @group.complete?)
    @cells.each { |cell| cell.value = 1 }
    assert_equal(true, @group.complete?)
  end
  
  def test_solve_singles
    (2..9).each { |i| @cells[i-1].value = i }
    assert_equal(true, @cells[0].empty?)
    @group.solve_singles
    assert_equal(false, @cells[0].empty?)
    assert_equal(1, @cells[0].value)
  end
  
  def test_solve_hidden_single
    (5..9).each { |i| @cells[i-1].value = i }
    @cells[0].candidates=[1,2,3]
    @cells[1].candidates=[1,3,4]
    @cells[2].candidates=[1,4]
    @cells[3].candidates=[1,3,4]    
    @group.solve_hidden_single
    assert_equal(2, @cells[0].value)
  end

  def test_solve_hidden_single_with_duplicate_value
    (5..9).each { |i| @cells[i-1].value = i }
    @cells[0].candidates=[1,6,3]
    @cells[1].candidates=[1,2,3,4]
    @cells[2].candidates=[1,2,4]
    @cells[3].candidates=[1,3,4]    
    @group.solve_hidden_single
    assert_not_equal(6, @cells[0].value)
  end

  def test_solve_naked_pairs
    (4..9).each { |i| @cells[i-1].value = i }
    @cells[0].candidates=[1,2]
    @cells[1].candidates=[1,2]
    @cells[2].candidates=[1,2,3]
    @group.solve_naked_group(2)
    assert_equal(true, @cells[0].empty?)
    assert_equal(true, @cells[1].empty?)
    assert_equal(3, @cells[2].value)
  end

  def test_solve_naked_triples
    (5..9).each { |i| @cells[i-1].value = i }
    @cells[0].candidates=[1,2,3]
    @cells[1].candidates=[1,2]
    @cells[2].candidates=[2,3]
    @cells[3].candidates=[1,2,3,4]
    @group.solve_naked_group(3)
    assert_equal(true, @cells[0].empty?)
    assert_equal(true, @cells[1].empty?)
    assert_equal(true, @cells[2].empty?)
    assert_equal(4, @cells[3].value)
  end

  def test_solve_naked_quad
    (6..9).each { |i| @cells[i-1].value = i }
    @cells[0].candidates=[1,2,3,4]
    @cells[1].candidates=[1,2,3]
    @cells[2].candidates=[2,3,4]
    @cells[3].candidates=[1,2,4]
    @cells[4].candidates=[1,2,3,4,5]
    @group.solve_naked_group(4)
    assert_equal(true, @cells[0].empty?)
    assert_equal(true, @cells[1].empty?)
    assert_equal(true, @cells[2].empty?)
    assert_equal(true, @cells[3].empty?)
    assert_equal(5, @cells[4].value)
  end

  def test_valid_success
    (1..9).each { |i| @cells[i-1].value = i }
    assert_equal(true, @group.complete?)
    assert_equal(true, @group.valid?)
  end
  
  def test_valid_failure
    (1..9).each { |i| @cells[i-1].value = i }
    @cells[5].value = 1
    assert_equal(true, @group.complete?)
    assert_equal(false, @group.valid?)
  end

  def test_empty_cells
    @cells[0].value = 1
    assert_equal(8, @group.empty_cells.size)
  end
  
end
