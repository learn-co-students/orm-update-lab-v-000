require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :id, :name, :grade
  
  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade 
  end# of initialize


  def self.create_table
    sql = <<-SQL 
    CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT)
    SQL
    
    DB[:conn].execute(sql) 
  end# of self.create_table
  
  
  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end# of self.drop_table
  
  
  def self.create(name, grade) 
    student = self.new(name, grade)
    student.save 
  end# of self.create
  
  
  def self.new_from_db(row)
   student = self.new(row[1], row[2])
   student.id = row[0]
   student 
  end# of self.new_from_db
  
  def update
   sql = <<~SQL 
   UPDATE students SET name = ?, grade = ? 
   WHERE id = ?
   SQL
   
   DB[:conn].execute(sql, self.name, self.grade, self.id)
  end# of update 
  
  
  def self.find_by_name(student_name)
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, student_name).flatten
    self.new_from_db(row)
  end# of self.find_by_name 
  
  def save
    if self.id
      self.update
      
    else
      sql = "INSERT INTO students (name, grade) VALUES (?,?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end# of if statement
  end# of save
  
  
  
end
