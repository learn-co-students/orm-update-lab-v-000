require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
  # id defaults to 'nil' on initialization
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
  # creates the students table in the database
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
  # drops the students table from the database
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def update
  # updates a record if called on an object that is already persisted
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
  # updates a record if called on an object that is already persisted
  # saves an instance of the Student class to the database
  # and then sets the given students `id` attribute
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
  # creates a student object with name and grade attributes
    new_student = Student.new(name, grade)
    new_student.save
  end

  def self.new_from_db(row)
  # creates an instance with corresponding attribute values
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(name, grade, id)
  end

  def self.find_by_name(name)
  # returns an instance of student that matches the name from the DB
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    row = DB[:conn].execute(sql,name)
    self.new_from_db(row[0])
  end

end
