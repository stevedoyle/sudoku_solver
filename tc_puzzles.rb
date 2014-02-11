require 'test/unit'
require_relative 'grid'

class TestPuzzles < Test::Unit::TestCase

  def setup
    @puzzles = []
    curr = ''
    open("puzzles.txt").each_line do |line|
      next if line =~ /^#/
      if line =~ /^\s*$/ 
        if not curr.empty?
          @puzzles << curr
          curr = ''
        end
      else
        curr += line.chomp
      end
    end
    @puzzles << curr if not curr.empty?
  end
  
  def test_puzzles_from_file
    @puzzles.each_with_index do |puzzle, idx|
      grid = Grid.new(puzzle)
      assert_equal(true, grid.solve, 
        message="Puzzle #{idx} solve error.\n#{grid}")
      assert_equal(true, grid.valid?,
        message="Puzzle #{idx} validation error.\n#{grid}")
    end
  end
  
end
