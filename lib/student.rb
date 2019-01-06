require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER)
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def update
    sql = <<-SQL
      UPDATE students 
      SET name=?, grade=?
      WHERE id=?
    SQL
    
    DB[:conn].execute(sql, @name, @grade, @id)
  end
  
  def save
    if self.id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].last_insert_row_id
    end
  end
  
  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end
  
  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name=?
    SQL
    
    row = DB[:conn].execute(sql, name)[0]
    new_from_db(row)
  end
end
