# encoding: utf-8
require "forwardable"

class Table
  extend Forwardable
  
  def initialize(array_of_rows = [])
    @table = array_of_rows
  end
  
  def rows
    @table
  end
  
  def_delegators :@table, :[], :<<
  def_delegator :@table, :count, :rows_count
end
