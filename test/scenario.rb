# encoding: utf-8

require "yaml"
require File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib",
    "table")

exam_data_file = File.join(File.expand_path(File.dirname(__FILE__)),
    "fixtures", "s1-exam-data.yaml")
exam_output_file = File.join(File.expand_path(File.dirname(__FILE__)),
    "s1-exam-data-transformed.yaml")

data = YAML::load(open(exam_data_file))
table = Table.new data, true

table.select_rows do |row|
  procedure_date = Date.strptime(row[0], "%m/%d/%y")
  procedure_date.month == 6 && procedure_date.year == 2006
end

[1,2,3].each do |index|
  table.map_column(index) do |ammount|
    sprintf "$%.2f", ammount.to_i/100
  end
end

table.map_column(0) do |date|
  parsed_date = Date.strptime(date, "%m/%d/%y")
  parsed_date.strftime("%Y/%m/%d")
end

table.delete_column_at "Count"

array_of_rows = table.rows.unshift(table.column_names)

File.open( exam_output_file, 'w' ) do |out|
   YAML.dump( array_of_rows, out )
end
