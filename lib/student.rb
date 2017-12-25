require 'pry'

require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
      sql =  <<-SQL 
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY, 
          name TEXT,
          grade INTEGER
          )
          SQL
      DB[:conn].execute(sql) 
  end

  def self.drop_table 
    sql =  <<-SQL 
    DROP TABLE students
      SQL
    DB[:conn].execute(sql) 
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(row)
    new_student = self.new
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
  
  # def self.new_from_db(row)
  #   @id = row[0]
  #   student.name = row[1]
  #   student.grade = row[2]
  #   student
  # end

  # def self.all
  #   sql = <<-SQL
  #     SELECT *
  #     FROM students
  #   SQL
 
  #   DB[:conn].execute(sql).map do |row|
  #     self.new_from_db(row)
  #   end
  # end

  # def self.find_by_name(name)
  #   sql = <<-SQL
  #     SELECT *
  #     FROM students
  #     WHERE name = ?
  #     LIMIT 1
  #   SQL
 
  #   DB[:conn].execute(sql, name).map do |row|
  #     self.new_from_db(row)
  #   end.first
  # end
  

  end