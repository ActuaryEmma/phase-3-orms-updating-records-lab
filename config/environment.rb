require 'sqlite3'
require_relative '../lib/student'

DB = {:conn => SQLite3::Database.new("db/students.db")}

# Student.create_table

# user = Student.new("Ja", "K")
# user.name
# puts user