require_relative "../config/environment.rb"
require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER,
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
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() from students')[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def self.create(name, grade, id = nil)
    student = Student.new(name, grade, id)
    student.save
    student
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.create(name, grade, id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT id, name, grade FROM students where name = ?
      SQL
    row = DB[:conn].execute(sql, name)[0]
    student = self.new_from_db(row)
  end

end
