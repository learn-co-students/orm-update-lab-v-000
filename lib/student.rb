require_relative "../config/environment.rb"
require "pry"
class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      update
    else
      sql = <<-SQL
      INSERT INTO students (
        name, grade) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student

  end

  def self.new_from_db(student_array)
    student = self.new(student_array[1], student_array[2], student_array[0])
  end

  def self.find_by_name(name)

    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    SQL
    student = DB[:conn].execute(sql, name).first
    object = self.new_from_db(student)
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?;
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end





end
