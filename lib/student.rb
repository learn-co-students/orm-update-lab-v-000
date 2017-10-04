require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-sql
        CREATE TABLE students ( id INTEGER PRIMARY KEY,
        name TEXT, grade INTEGER)
    sql

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-sql
        DROP TABLE students
    sql

    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(student)
    new_student = Student.new(student[0], student[1], student[2])
    new_student
  end

  def save
      if self.id
        self.update
      else
      sql = <<-sql
        INSERT INTO students (name, grade) VALUES (?, ?)
      sql

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid()FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save

    new_student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"

   student = DB[:conn].execute(sql, name)[0]
   self.new_from_db(student)

  end

  end
