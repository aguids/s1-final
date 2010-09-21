# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "..", "test_helper")

class TableTest < Test::Unit::TestCase
  
  def array_of_rows
    [ ["name", "age", "job"],
      ["john", 20, nil],
      ["steve", 40, "programmer"]
    ]
  end
  
  describe "creation" do
    test "may start empty" do
      table = Table.new
      assert_equal 0, table.rows_count
    end
    
    test "accepts an array of rows" do
      table = Table.new(array_of_rows)
      assert_equal 3, table.rows_count
    end
  end
  
end
