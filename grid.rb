# A sudoko grid - 9x9 cells

require_relative 'cell'
require_relative 'cellGroup'

class Grid
  
  def initialize(puzzle)
    @cells = Array.new(9*9) { Cell.new }
    
    # Create the groupings ...    
    @rows = Array.new(9) { |i| CellGroup.new(@cells[(i*9)...((i+1)*9)]) }
    @cols = Array.new(9) { |i| CellGroup.new((0..8).map { |x| @cells[(x*9)+i] }) }
    
    boxes = [[0,1,2,9,10,11,18,19,20],
      [3,4,5,12,13,14,21,22,23],
      [6,7,8,15,16,17,24,25,26],
      [27,28,29,36,37,38,45,46,47],
      [30,31,32,39,40,41,48,49,50],
      [33,34,35,42,43,44,51,52,53],
      [54,55,56,63,64,65,72,73,74],
      [57,58,59,66,67,68,75,76,77],
      [60,61,62,69,70,71,78,79,80]]
    @boxes = Array.new(9) { |i| CellGroup.new(boxes[i].map { |x| @cells[x] }) }
    
    @groups = [@rows, @cols, @boxes].flatten
    
    # parse the puzzle and assign known values
    puzzle.gsub!(/\s/, '')
    (0...puzzle.length).each do |i| 
      val = puzzle[i].chr
      @cells[i].value = val.to_i if val != "*"
    end  
    
    # initially mark teh grid as unmodified
    clear_modification_status
  end
  
  def assign(row, col, val)
    @cells[(row*9)+col].value = val
  end
  
  def get(row, col)
    @cells[(row*9)+col].value
  end
  
  def count_empty_cells
    @cells.inject(0) { |count, cell| (cell.empty?) ? count+1 : count }
  end
  
  def complete?
    @cells.select { |cell| cell.empty? }.empty?
  end
  
  def modified?
    not @cells.select { |cell| cell.modified? }.empty?
  end
  
  def clear_modification_status
    @cells.each { |cell| cell.clear_modification_status }
  end
  
  def solve
    return true if solve_using_logic
    # Could not be solved using the pure logic encoded within each of the groups.
    # Try guessing!    
    solve_using_guess
  end
  
  def solve_using_logic
    while not complete?
      clear_modification_status
      @groups.each { |row| row.solve }
      return false if not modified?
    end
    return true
  end
  
  def solve_using_guess
    originalCells = @cells
    make_guess do |guess|
      @cells = guess
      solve_using_logic
      return true if complete? and valid?
      puts "Empty: #{originalCells.inject(0) {|count,cell| cell.empty? ? count+1 : count } }"
    end
    # No solution found - restore the original cells before guessing
    @cells = originalCells
    return false
  end

  def valid?
    @groups.reject { |group| group.valid? }.empty?
  end
  
  def to_s
    out = []
    (0..8).each do |row|
      out << @cells[(row*9)...((row+1)*9)].map { |cell| cell.to_s }.join(' ')
    end
    out.join("\n")
  end
  
  def make_guess
    origCells = Array.new(@cells.size) { @cells.map { |cell| cell.dup } }
    origCells.each_with_index do |cell, idx| 
      next if not cell.empty?
      guess = Array.new(origCells.size) { origCells.map { |cell| cell.dup } }
      cell.candidates.each do |candidate|
          guess[idx].value = candidate          
          yield guess
      end
    end
  end
  
end

