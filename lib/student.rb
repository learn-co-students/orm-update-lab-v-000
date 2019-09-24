require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      album TEXT )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.find_by_name(name)
    sql = " SELECT * FROM students WHERE name = ?"
      result = DB[:conn].execute(sql,name)[0]
      # binding.pry
      Student.new(result[1],result[2])

  end


 def update
   sql = "UPDATE students SET name = ?, grade = ? WHERE name = ?"
   DB[:conn].execute(sql, self.name, self.grade, self.name)
 end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
