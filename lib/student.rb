require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    students = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
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
    if self.id
      self.update
    else
    students = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL

    DB[:conn].execute(students, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    students = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL

    DB[:conn].execute(students, name).collect do |student|
      self.new_from_db(student)
    end.first
  end

  def update
    students = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(students, self.name, self.grade, self.id)
  end
end
