require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name,:grade
    attr_reader :id

    def initialize(name,grade,id=nil)
      #id is nil because it will be given from the table.
      @name = name
      @grade = grade
      @id = id
    end

    def self.create_table
      #creates the table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id integer PRIMARY KEY,
      name TEXT,
      grade INTEGER
      )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      #deletes the table.
      sql = <<-SQL
      DROP TABLE students;
      SQL
      DB[:conn].execute(sql)
    end

    def save
      #saves the song object to the table
      if self.id #has an id not nil
        self.update
      else
      sql = <<-SQL
      INSERT INTO students (name,grade)
      VALUES
      (?,?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end

    def self.create(name,grade) #no need for mass assignment
      #creates the song in ruby so that you don't have to assign it to a variable.
      student = Student.new(name,grade)
      student.save
      student
    end

    def self.new_from_db(row)
      # create a new Student object given a row from the database
      #new_student = self.new WHERE THE PARAMETERS AT
      #new_student.id = row[0]
      #new_student.name = row[1]
      #new_student.grade = row[2]
      #new_student
      id = row[0]
      name = row[1]
      grade = row[2]
      self.new(name,grade,id)
    end

    def self.find_by_name(name)
      # find the student in the database given a name
      # return a new instance of the Student class
      sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL

      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
    end.first
  end

    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      #uses the unique id of a student to make sure you are updating the right student.
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

end
