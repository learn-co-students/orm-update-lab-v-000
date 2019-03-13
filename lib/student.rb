require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize (id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students IF NOT EXISTS (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = "DROP TABLE students"
    
    DB[:conn].execute(sql)
  end
  
  def save
    
  end
  
  def self.create
    
  end
  
  def self.new_from_db
    
  end
  
  def self.find_by_name
    
  end
  
  def update
    
  end

end
