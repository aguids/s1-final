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
  
  def array_of_rows_data
    @array_of_rows_data ||= array_of_rows[1..-1]
  end
  
  def array_of_columns
    @array_of_columns ||= array_of_rows.transpose
  end

  def array_of_columns_data
    @array_of_columns_data ||= array_of_rows_data.transpose
  end
  
  describe "creation" do
    test "may start empty" do
      table = Table.new
      assert_equal 0, table.rows_count
    end
    
    test "accepts an array of rows" do
      table = Table.new array_of_rows_data
      assert_equal array_of_rows_data.count, table.rows_count
    end
    
    describe "with header support" do
      setup do
        @table = Table.new array_of_rows, true
      end
      
      test "remove the first row from the table data" do
        assert_equal array_of_rows_data.count, @table.rows_count
        assert_equal array_of_rows_data[0], @table.rows[0]
      end
      
      test "treats the first row as column names" do
        assert_equal array_of_rows[0].map(&:to_sym), @table.header_row
      end
      
      test "has no side effects on params" do
        data = array_of_rows
        new_table = Table.new data, true
        assert_equal array_of_rows, data
      end
    end
  end
  
  describe "row manipulation" do
    setup do
      @table = Table.new array_of_rows
    end
    
    test "retrieve row by index" do
      assert_equal array_of_rows[1], @table.rows[1]
      assert_equal array_of_rows[1], @table[1]
    end
    
    describe "append" do
      
      test "append row to the end of the table" do
        row = ["stuart", 35, nil]
        @table << row
        assert_equal row, @table[@table.rows_count - 1]
      end  
    
      test "has no side effects on params" do
        row = ["stuart", 35, nil]
        @table << row
        @table[@table.rows_count - 1].shift
        
        assert_not_equal row, @table[@table.rows_count - 1]
      end
    end
    
    describe "insert" do
      
      test "insert row at position" do
        row = ["stuart", 35, nil]
        @table.insert_row_at 1, row
        assert_equal row, @table[1]
      end

      test "has no side effects on params" do
        row = ["stuart", 35, nil]
        @table.insert_row_at 1, row
        @table[1].shift
        
        assert_not_equal row, @table[1]
      end
    end
    
    test "delete row" do
      @table.delete_row_at(1)
      assert_not_equal array_of_rows[1], @table[1]
      assert_not_equal array_of_rows.count, @table.rows_count
    end
  end
  
  describe "column manipulation" do
    setup do
      @table = Table.new array_of_rows, true
    end
    
    test "retrieve column by index" do
      assert_equal array_of_columns_data[1], @table.columns[1]
    end
    
    test "retrieve column by name" do
      assert_equal array_of_columns_data[1], @table["age"]
      assert_equal array_of_columns_data[1], @table[:age]
    end
    
    describe "append" do
      
      test "append column to the right of the table" do
        column = ["sport", "golf", nil, "soccer"]
        @table.append_column column
        assert_equal column[1..-1], @table.columns[@table.columns_count - 1]
      end
      
      test "has no side effects on params" do
        column = ["sport", "golf", nil, "soccer"]
        @table.append_column column
        @table[0][@table.columns_count - 1] = nil
        
        assert_not_equal column[1..-1], @table.columns[@table.columns_count - 1]
      end
    end

    describe "insert" do
      
      test "insert column at position" do
        column = ["sport", "golf", nil, "soccer"]
        @table.insert_column_at 1, column
        assert_equal column[1..-1], @table.columns[1]
      end
      
      test "has no side effects on params" do
        column = ["sport", "golf", nil, "soccer"]
        @table.insert_column_at 1, column
        @table[0][1] = nil
        
        assert_not_equal column[1..-1], @table.columns[1]
      end
    end

    test "delete column at position" do
      @table.delete_column_at 1
      assert_not_equal array_of_columns[1], @table.columns[1]
      assert_not_equal array_of_columns.count, @table.columns_count
    end
  end

end      