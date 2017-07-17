require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_reader :id
  attr_accessor :name, :grade

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
    grade TEXT);
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
    if @id
      sql = <<-SQL
            UPDATE students
            SET name = ?, grade = ?
            WHERE id = ?;
            SQL

      DB[:conn].execute(sql, self.name, self.grade, @id)    
    else
      sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?,?);
          SQL

      DB[:conn].execute(sql, self.name, self.grade)

      sql_for_id = <<-SQL
          SELECT id
          FROM students
          WHERE name = ?;
          SQL
      @id = DB[:conn].execute(sql_for_id, self.name).flatten.first
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    student = self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    # This class method takes in an argument of a name. 
    # It queries the database table for a record that has
    #  a name of the name passed in as an argument. 
    #  Then it uses the #new_from_db method to instantiate a 
    #  Student object with the database row that the SQL query returns.

    sql = <<-SQL
          SELECT *
          FROM students
          WHERE name = ?;
          SQL

    student_row = DB[:conn].execute(sql, name).flatten
    #binding.pry
    self.new_from_db(student_row)
  end

  def update
    # This method updates the database row mapped to the given Student instance.
    self.save
  end

end
