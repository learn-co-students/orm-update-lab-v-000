require_relative "../config/environment.rb"
require 'pry'

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(id= nil, name, grade )
    @name, @grade, @id = name, grade, id
  end

  def self.create_table
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
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(row)
    student = Student.new(row[0], row[1], row[2])
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
      # binding.pry
    end.first
  end

  def save
    if self.id
      self.update
    else
      self.class.create(self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
    end
  end

end
