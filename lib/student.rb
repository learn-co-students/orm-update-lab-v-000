require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id = nil, name, grade)
    @id, @name, @grade = id, name, grade
  end #initialize
  
  
  #Creates a new table in the database
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
    SQL
    
    DB[:conn].execute(sql)
  end #create_table
  
  
  #If object already persists, updates the data
  #Else Inserts new data
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end #if self.id
  end #save
  
  
  #Creates new objects and saves them to the database
  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end #.create
  
  
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end #.drop_table
  
  
  #Creates new objects from data in the database table
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end #new_from_db
  
  
  #Finds the first entry with the specified name
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL
    
    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end #.find_by_name
  
  
  #Updates an entry in the table
  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end #update
end #Class Student
