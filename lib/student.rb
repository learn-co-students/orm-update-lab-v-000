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
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
end 

def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
end

def save
  if !self.id   
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  else 
    sql = <<-SQL 
       UPDATE students SET name = ?, grade = ? WHERE id = ?
       SQL
       
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end 
 end
 
 def self.create(name, grade) 
    x = Student.new(name, grade)
    x.save 
    x
  end 
  
  def self.new_from_db(row)
    y = Student.new(row[1], row[2], row[0]) 
    y 
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    x = DB[:conn].execute(sql, name).flatten 
    
    y = Student.new_from_db(x) 
    y
  end
  
  def update 
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)  
    
  end 
end
# Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]