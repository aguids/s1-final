# encoding: utf-8
require "forwardable"

class Table
  
  def initialize(array_of_rows = [], header_support = false)
    @table = array_of_rows.dup
    
    @header_support = header_support
    @column_names = @table.shift.map(&:to_s) if header_support
  end
  
  attr_accessor :column_names
  
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
  
  def rename_column(index_or_name, new_name)
    return unless @header_support
    
    index = column_index(index_or_name)
    @column_names[index] = new_name
  end
  
  def columns_count
    rows.first.count
  end
  
  def append_column(column)
    new_columns = columns
    new_columns << column.dup
    
    @column_names << new_columns.last.shift if @header_support
      
    update_columns(new_columns)
  end
  
  def insert_column_at(index_or_name, column)
    index = column_index(index_or_name)
    
    new_columns = columns
    new_columns.insert index, column.dup
    
    @column_names.insert(index, new_columns[index].shift) if @header_support
    
    update_columns(new_columns)
  end
  
  def delete_column_at(index_or_name)
    index = column_index(index_or_name)
    
    new_columns = columns
    new_columns.delete_at index
    update_columns(new_columns)
    
    @column_names.delete_at index if @header_support
  end
  
  def [](row_index_or_column_name)
    return rows[row_index_or_column_name] unless @header_support
    
    case row_index_or_column_name
    when String
      columns[column_index(row_index_or_column_name)]
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
  
  def column_index(index_or_name)
    return index_or_name unless @header_support
    
    if String === index_or_name
      @column_names.index(index_or_name) 
    else
      index_or_name
    end
  end
end
