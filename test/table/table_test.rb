# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "test_helper")

class TableTest < Test::Unit::TestCase
  
  def array_of_rows
    [ ["name", "age", "job"],
      ["john", 20, nil],
      ["steve", 40, "programmer"],
      ["mary", 28, "model"]
    ]
  end
  
  def array_of_columns
    array_of_rows.transpose
  end
  
  describe "creation" do
    test "starts empty" do
      table = Table.new
      assert_equal 0, table.rows_count
    end
    
    test "accepts an array of rows" do
      table = Table.new(array_of_rows)
      assert_equal array_of_rows.count, table.rows_count
    end
  end
  
  describe "row manipulation" do
    setup do
      @table = Table.new array_of_rows
    end
    
    test "retrieve row by index" do
      assert_equal array_of_rows[2], @table.rows[2]
      assert_equal array_of_rows[2], @table[2]
    end
      
    test "append row to the end of the table" do
      row = ["stuart", 35, nil]
      @table << row
      assert_equal row, @table[@table.rows_count - 1]
    end
    
    test "insert row at position" do
      row = ["stuart", 35, nil]
      @table.insert_row_at 2, row
      assert_equal row, @table[2]
    end
    
    test "delete row" do
      @table.delete_row_at(2)
      assert_not_equal array_of_rows[2], @table[2]
      assert_not_equal array_of_rows.count, @table.rows_count
    end
  end
  
  describe "column manipulation" do
    setup do
      @table = Table.new array_of_rows
    end
    
    test "retrieve column by index" do
      assert_equal array_of_columns[1], @table.columns[1]
    end
    
    test "append column to the right of the table" do
      column = ["sport", "golf", nil, "soccer"]
      @table.append_column column
      assert_equal column, @table.columns[@table.columns_count - 1]
    end

    test "insert column at position" do
      column = ["sport", "golf", nil, "soccer"]
      @table.insert_column_at 1, column
      assert_equal column, @table.columns[1]
    end

    test "delete column at position" do
      @table.delete_column_at 1
      assert_not_equal array_of_columns[1], @table.columns[1]
      assert_not_equal array_of_columns.count, @table.columns_count
    end
  end
  
end
