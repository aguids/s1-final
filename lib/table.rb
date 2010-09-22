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
  
  def columns
    @table.transpose
  end
  
  def columns_count
    rows.first.count
  end
  
  def append_column(column)
    new_columns = columns << column
    update_columns(new_columns)
  end
  
  def insert_column_at(index, column)
    new_columns = columns.insert index, column
    update_columns(new_columns)
  end
  
  def delete_column_at(index)
    new_columns = columns
    new_columns.delete_at index
    update_columns(new_columns)
  end
  
  def_delegators :@table, :[], :<<
  
  def_delegator :@table, :count,     :rows_count
  def_delegator :@table, :insert,    :insert_row_at
  def_delegator :@table, :delete_at, :delete_row_at

private
  def update_columns(new_columns)
    @table = new_columns.transpose
  end
end
