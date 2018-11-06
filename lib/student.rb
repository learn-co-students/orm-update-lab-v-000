require_relative "../config/environment.rb"

require 'pry'
class Student
  attr_accessor :name, :grade, :id 
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name, grade)
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


  def save 
    if self.id != nil 
      self.update 
    else 
      self.save_new  
    end 
  end 
  
  def save_new
      sql = <<-SQL
        INSERT INTO students (name, grade) 
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id =  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    self 
  end

  def self.create(name, grade)
    new_guy = Student.new(name, grade)
    new_guy.save 
  end 

  def self.new_from_db(row)
     Student.new(row[0], row[1], row[2])
  end 

  def self.find_by_name(name)
    sql = <<-SQL 
    SELECT * from students where name = ?
    SQL
    
    data = DB[:conn].execute(sql, name).first 
    self.new_from_db(data)
  end 

end 