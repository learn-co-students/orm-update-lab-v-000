require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT)
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
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(params)
    student = Student.new(params[:name], params[:grade])
    student.save
    student
  end

  def self.new_from_db(row)
    student = Student.new(row[1], row[2], row[0])
    student.save
    student
  end

  def self.find_by_name(n)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL
    info = DB[:conn].execute(sql, n)[0]
    Student.new(info[1], info[2], info[0])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)

  end

 
end
