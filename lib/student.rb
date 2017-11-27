require_relative "../config/environment.rb"
require 'pry'
class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
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
        DROP TABLE students
        SQL

    DB[:conn].execute(sql)
  end

#inserts a new row into db using the attrs of calling object and assigns object's id via the db's id.
  def save
    if self.id   #update instead of insert if ID already exists
      self.update
    else
      sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
          SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #grabs and assigns ID via 'last insert_row_id()' from table.
    end
  end

  def self.create(name, grade) #This function creates a student with two attributes, name and grade. Haven't the faintest what the name:, grade: were before.
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(table_row)
    id = table_row[0]    #vars set here. no obj.property= setters.
    name = table_row[1]
    grade = table_row[2]

    student = self.new(id, name, grade)
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
        SELECT * FROM students WHERE name = ?
        LIMIT 1
    SQL
    #binding.pry
    student_row = DB[:conn].execute(sql, name).flatten
    new_from_db(student_row)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? where id = ?"
    DB[:conn].execute(sql, name = self.name, grade = self.grade, id = self.id)
  end

end
