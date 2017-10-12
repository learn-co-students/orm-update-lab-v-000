require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    students = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER,
    )
    SQL

    DB[:conn].execute(students)
  end

  def self.drop_table
    students = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(students)
  end

  def save
    students = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL

    DB[:conn].execute(students, self.name, self.grade)

    @id = DB[:conn].execute("SELECT id FROM last_insert_rowid() FROM students")[0]
  end

  def self.create(name, grade)
    student = Self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    
  end
end
