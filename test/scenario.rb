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

table.select_rows { |row| row[0].match /^06/ }

[1,2,3].each do |index|
  table.map_column(index) do |ammount|
    sprintf "$%.2f", ammount.to_i/100
  end
end

table.map_column(0) do |date|
  month, date, year = date.split("/")
  "20#{year}/#{month}/#{date}"
end

table.delete_column_at "Count"

array_of_rows = table.rows.unshift(table.column_names)

File.open( exam_output_file, 'w' ) do |out|
   YAML.dump( array_of_rows, out )
end
