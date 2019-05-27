require_relative "../config/environment.rb"

class Student
  
  attr_accessor :id, :name, :grade
  
  def initialize (name, grade, id=nil) 
    #method takes three arguments
    @id = id
    @name = name
    @grade = grade
  end 
  
  def self.create_table 
    #class method creates students table that matches attributes of indivdual students 
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER)
      SQL
    
    DB[:conn].execute(sql)  
  end   
    
  def self.drop_table
    # class method responsible for dropping students table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end   

  def save
    # instance method inserts a new row into the database using attributes of given object
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name,grade) VALUES (?,?)
      SQL
    
      DB[:conn].execute(sql,self.name,self.grade)
    # assigns id attribute of the object once the row has inserted into database
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end   
  end 
  
  def self.create (name, grade)
    # method creates a student with name and grade attribute then saves into students table
    student = self.new(name,grade)
    student.save
    student
  end   

  def self.new_from_db(row)
    #class method uses three array elements (id,name,grade) to create a new Student object
    student = self.new(row[1],row[2],row[0])
    student
  end
  
  def self.find_by_name(name)
    #class method take name argument; queries database table for record then uses the new_from_db method to instantiate a Student object with database row the SQL query returns
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1 
    SQL
  
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first        
  end   
  
  def update 
    # method updates database row mapped to given Student instance
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
      
    DB[:conn].execute(sql, self.name, self.grade, self.id)  
  end
  
end
