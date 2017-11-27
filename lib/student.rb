class Student

  require_relative "../config/environment.rb"

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT)
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
    
    if self.id
       self.update
     else
    sql = <<-SQL
    INSERT INTO
    students(name, grade)
    VALUES (?, ?)
  SQL
  
  DB[:conn].execute(sql, @name, @grade)
  
  @id = DB[:conn].execute("SELECT id FROM students WHERE NAME = ?", @name)[0][0]
end
end

def self.create(name, grade)
  sql = <<-SQL
  INSERT INTO
  students(name, grade)
  VALUES(?, ?)
  SQL
  
  DB[:conn].execute(sql, name, grade)
end

def self.new_from_db(row)
  student = self.new(row[1], row[2], row[0])
  student
end
  
  

def update 
  sql = <<-SQL
  UPDATE students
  SET name = ?, grade = ?
  SQL
  
  DB[:conn].execute(sql, @name, @grade)
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT *
  FROM students
  WHERE name = ?
  SQL
  
  row = DB[:conn].execute(sql, name)[0]
  new_from_db(row)
  end  
    

end
