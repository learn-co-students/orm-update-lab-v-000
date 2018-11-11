require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    
    if self.id
      self.update
    else
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT id FROM students WHERE name = ?",self.name)[0][0]
    end
  end
  
  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end
  
  def self.new_from_db(row)
    student = Student.new(row[0], row[1], row[2])
  end
  
 def self.find_by_name(name)
   row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0]
   Student.new_from_db(row)
 end

end
