require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade,id = nil)
    @name = name
    @grade = grade
    @id = id
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

  def save
    if self.id == true
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name,grade) 
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(row)
    student = Student.new(row[:name], row[:grade])
    student.save
  end

  def self.new_from_db(row)
    new_song = self.new(row[1],row[2],row[0])
    new_song
  end
 
  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE students.name = ?
    LIMIT 1
    SQL
    DB[:conn].execute(sql, name).collect do |student|
      self.new_from_db(student)
    end.first
  end

  def update
    save
  end


end
