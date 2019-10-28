require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id
      self.update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    name = row[1]
    grade = row[2]
    student = Student.new(name, grade)
    student.id = row[0]
    student
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    self.new_from_db(row)
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", self.name, self.grade, self.id)
  end

end
