require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

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
      DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    id = <<-SQL
      SELECT last_insert_rowid() FROM students;
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute(id)[0][0]
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = ?
    SQL

    result = DB[:conn].execute(sql, name)
    Student.new(result[0][1], result[0][2], result[0][0])
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end



  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
 
end
