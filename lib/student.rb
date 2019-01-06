require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id = nil, name, grade)
    @id = id 
    @name = name 
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students( 
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
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

  def save
    if self.id 
      update
    else
    sql = <<-SQL
      INSERT INTO students(name, grade) VALUES(?, ?)
    SQL
    DB[:conn].execute(sql, @name, @grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update 
    sql = <<-SQL
      UPDATE students SET
        name = ?,
        grade = ?
          WHERE id = ?
    SQL
    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def self.create(name, grade)
    self.new(name, grade).save
  end

  def self.new_from_db(arr)
    self.new(arr[0], arr[1], arr[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE students.name = ? 
    SQL
    result = DB[:conn].execute(sql, name)[0]
    self.new(result[0], result[1], result[2])
  end
end
