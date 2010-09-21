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
  end
  
  describe "row addition" do
    describe "with an empty table" do
      setup do
        @table = Table.new
        @row = ["stuart", 50, nil]
        @table << @row
      end
      
      test "appends the row to the start of the table" do
        assert_equal @row, @table[0]
      end
    end
    
    describe "with an existing table" do
      setup do
        @table = Table.new array_of_rows
        @row = ["stuart", 50, nil]
        @table << @row
      end
      
      test "appends the row to the end of the table" do
        assert_equal @row, @table[@table.rows_count - 1]
      end
    end
  end
  
end
