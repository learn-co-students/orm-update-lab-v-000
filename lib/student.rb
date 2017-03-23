require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name,:grade,:id

  @@all = []

  def initialize(id=nil,name,grade)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql =  <<-SQL
      DROP TABLE IF EXISTS students
        SQL

    DB[:conn].execute(sql)
  end

  def self.create(name,grade)
    new_student = Student.new(name,grade)
    new_student.save
  end

  def save
    if id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name,grade) VALUES (?,?)
      SQL

    DB[:conn].execute(sql,self.name,self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
    self
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?,
        grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    new_student = Student.new(id,name,grade)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
      SQL

    db_return_value = DB[:conn].execute(sql,name)

    @@all.each do |student|
      if student.name == name
        @found_student = student
      end
    end
    @found_student
  end

end
