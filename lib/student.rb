require_relative "../config/environment.rb"
require "pry"

class Student
  attr_accessor :name, :grade, :id
  
  def initialize(name, grade)
    self.name = name
    self.grade = grade
    self.id = nil
  end

  def self.create_table
    DB[:conn].execute(
      "CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )"
    )
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def self.create(name, grade)
    student = new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = new(row[1], row[2])
    student.id = row[0]
    student
  end

  def self.find_by_name(name)
    new_from_db(
      DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0]
    )
  end

  def save
    if self.id
      update
    else
      DB[:conn].execute(
        "INSERT INTO students (name, grade) VALUES (?, ?)",
        self.name, self.grade
      )
      self.id = DB[:conn].execute(
        "SELECT last_insert_rowid() FROM students"
      )[0][0]
    end
  end

  def update
    DB[:conn].execute(
      "UPDATE students SET name = ?, grade = ? WHERE id = ?",
      self.name, self.grade, self.id
    )
  end

end
