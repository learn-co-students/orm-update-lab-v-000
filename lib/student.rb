require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    array_of_student_info = DB[:conn].execute(sql, name).flatten
    self.new_from_db(array_of_student_info)
  end

  def self.new_from_db(row)
    new_student = Student.new(row[0], row[1], row[2])
  end

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade= ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end  
 
end
