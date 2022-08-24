require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  # attr_reader :id
  def initialize(id = nil, name, grade )
    @id = id
    @name = name
    @grade = grade
   
  end

  #create table
  def self.create_table
    #query that create the table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL
   
    DB[:conn].execute(sql)
  end
  
  # #drop_table
  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  #save
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES(?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  
  end 

  # #create
  def self.create(name, grade)
    student = Student.new( name, grade)
    student.save
  end

  #new_from_db
  def self.new_from_db(row)
    self.new(id = row[0], name = row[1], grade = row[2])
  end

  #find by name
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end


  #update
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  

end
