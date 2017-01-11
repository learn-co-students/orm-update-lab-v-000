require_relative "../config/environment.rb"
require 'pry'


class Student

  attr_accessor :id, :name, :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil

  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    new_student = Student.new(row[1], row[2])
    new_student.id = row[0]
    new_student
  end

  def self.find_by_name(name)

    find_sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    student_row_array = DB[:conn].execute(find_sql,name)
    new_student = Student.new_from_db(student_row_array[0])
    new_student

  end

  def self.create_table

    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)

  end

  def self.drop_table

    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)

  end

  def update

    update_sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(update_sql,self.name,self.grade,self.id)

  end


  def save

    insert_sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
    SQL

    if self.id == nil then
      DB[:conn].execute(insert_sql,self.name,self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      self.update
    end

  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
