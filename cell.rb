
class Cell
  attr_reader :value
  attr :candidates, true
  
  def initialize
    @value = nil
    @candidates = (1..9).to_a
    @modified = false
  end 

  # Does the cell have a value?
  def empty?
    return @value == nil
  end

  # Eliminate a value from the possible values that the cell can hold
  def eliminate(val)
    @modified = true if @candidates.delete(val) != nil
    @value = @candidates.first if @candidates.size == 1
  end
  
  # Set the cell's value. 
  # Note this is done explicitly here rather than using attr or attr_writer 
  # as there are additional consequences to writing a cells value
  def value=(val)
    @value = val
    @candidates = []
    @modified = true
  end
   
  # Is this value allowed in the cell?
  def allowed?(val)
    return @candidates.include?(val)
  end  
  
  # Has this cell been modified?
  def modified?
    @modified
  end
  
  # Clear the modification status
  def clear_modification_status
    @modified = false
  end
  
  def to_s
    @value == nil ? '*' : @value
  end
  
end
