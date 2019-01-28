require_relative "../config/environment.rb"
require 'pry'

class Student
  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
    
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
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
    if self.id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      
     DB[:conn].execute(sql, self.name, self.grade)
     #grab the ID of the row just inserted into the database and assign it to the value of @id attribute of this instance
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end
  
  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade) #create instance with two attributes
    student.save #save instance into students table
    student
  end
  
  def self.new_from_db(row)
    new_student = self.new(name = row[1], grade = row[2])
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
  
  def self.find_by_name(name)
    #binding.pry
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
  end
  
end
