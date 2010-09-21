# encoding: utf-8

class Table
  
  def initialize(array_of_rows = [])
    @table = array_of_rows
  end
  
  def rows_count
    @table.count
  end
end
