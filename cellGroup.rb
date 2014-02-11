# A group of cells within a Sudoku grid.
# A group consists of 9 cells from either:
# * A row
# * A column
# * A 3x3 box

require_relative 'cell'

class CellGroup
  
  def initialize(cells)
    @cells = cells
  end
  
  # Is the group complete - i.e. does each cell in the group have a value?
  def complete?    
    @cells.select { |cell| cell.empty? }.empty?
  end
  
  def solve
    solve_singles
    solve_hidden_single
    (2..4).each { |size| solve_naked_group(size) }
  end
  
  def solve_singles
    # Eliminate the singles - cells that have only one candidate
    @cells.each do |cell|
      next if cell.empty?
      empty_cells.each do |other|
        next if other == cell
        other.eliminate(cell.value)
      end
    end
  end
  
  def solve_hidden_single
    empty_cells.each do |cell|
      candidates = cell.candidates.dup
      empty_cells.each do |other|
        next if cell == other
        candidates -= other.candidates
      end
      if candidates.size == 1
        next if not @cells.select { |x| x.value == candidates.first }.empty?
        cell.value = candidates.first
      end
    end
  end
  
  # A naked group is a group of cells which contain the same set of 
  # candidate values. For example cells with candidates [1,2,3],[1,2],[2,3]
  # form a triple. Any other cells within a group that contain these 
  # candidate values can remove these values from their candidate lists.
  def solve_naked_group(size)
    empty_cells.each do |cell|
      next if cell.candidates.size != size
      partners = find_cells_with_candidate_subsets(cell)
      # puts "Partners size: #{partners.size}"
      next if partners.size != size-1
      partners << cell
      empty_cells.each do |other|
        next if partners.include?(other)
        cell.candidates.each { |x| other.eliminate(x) }
      end
    end
  end

  def valid?
    values = @cells.collect { |cell| cell.value }.sort
    values.each_with_index { |val, i| return false if val != (i+1) }
    return true
  end
  
  def empty_cells
    @cells.select { |cell| cell.empty? }
  end
   
  def find_cells_with_candidate_subsets(target)
    partners = empty_cells.select do |c| 
      (target.candidates | c.candidates).size == target.candidates.size and c != target
    end
    # puts target.candidates.join(' ')
    # partners.each { |cell| puts cell.candidates.join(' ') }
  end
end
