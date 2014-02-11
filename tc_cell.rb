require 'test/unit'
require_relative 'cell'

class CellTests < Test::Unit::TestCase

  def setup
    @cell = Cell.new
  end 

  def test_initialState
    assert_nil(@cell.value)
    assert_equal([1,2,3,4,5,6,7,8,9], @cell.candidates)
  end

  def test_assignment
    @cell.value = 6
    assert_equal(6, @cell.value)
    assert_equal([], @cell.candidates)
  end

  def test_empty
    assert_equal(true, @cell.empty?)
    @cell.value = 1
    assert_equal(false, @cell.empty?)
  end
  
  def test_eliminate_1
    assert_equal(true, @cell.candidates.include?(5))
    @cell.eliminate(5)
    assert_equal(false, @cell.candidates.include?(5))    
  end
  
  def test_eliminate_2
    (1..8).each { |i| @cell.eliminate(i) }
    assert_equal(9, @cell.value)
  end

  def test_allowed_1
    assert_equal(true, @cell.allowed?(6))
    @cell.eliminate(6)
    assert_equal(false, @cell.allowed?(6))
  end

  def test_allowed_2
    assert_equal(true, @cell.allowed?(6))
    @cell.value = 5
    assert_equal(false, @cell.allowed?(6))
  end
  
  def test_modified_1
    assert_equal(false, @cell.modified?)
    @cell.value = 2
    assert_equal(true, @cell.modified?)    
    @cell.clear_modification_status
    assert_equal(false, @cell.modified?)
  end

  def test_modified_2
    @cell.eliminate(2)
    assert_equal(true, @cell.modified?)    
  end

end
