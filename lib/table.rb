# encoding: utf-8
require "forwardable"

class Table
  
  def initialize(array_of_rows = [], header_support = false)
    @table = array_of_rows.dup
    
    @header_support = header_support
    @header_row = @table.shift.map(&:to_sym) if header_support
  end
  
  attr_reader :header_row
  
  def rows
    @table
  end
  
  def append_row(row)
    @table << row.dup
  end
  alias :<< :append_row
  
  def insert_row_at(index, row)
    @table.insert(index, row.dup)
  end
  
  def columns
    @table.transpose
  end
  
  def columns_count
    rows.first.count
  end
  
  def append_column(column)
    new_columns = columns
    new_columns << column.dup
    
    @header_row << new_columns.last.shift if @header_support
      
    update_columns(new_columns)
  end
  
  def insert_column_at(index, column)
    new_columns = columns
    new_columns.insert index, column.dup
    
    @header_row.insert(index, new_columns[index].shift) if @header_support
    
    update_columns(new_columns)
  end
  
  def delete_column_at(index)
    new_columns = columns
    new_columns.delete_at index
    update_columns(new_columns)
    
    @header_row.delete_at index if @header_support
  end
  
  def [](row_index_or_column_name)
    return rows[row_index_or_column_name] unless @header_support
    
    case row_index_or_column_name
    when String, Symbol
      index = @header_row.index(row_index_or_column_name.to_sym)
      columns[index]
    else
      rows[row_index_or_column_name]
    end
  end
  
  extend Forwardable
  def_delegator :@table, :count,     :rows_count
  def_delegator :@table, :delete_at, :delete_row_at

private
  def update_columns(new_columns)
    @table = new_columns.transpose
  end
end
