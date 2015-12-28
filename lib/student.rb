require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    self
  end
  
  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS students(
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
    if @id #if it already has an id, then update the entry rather than creating a new one in the SQL table
      update
    else
      sql = <<-SQL 
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, @name, @grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] #gets id for row assigned by database when inserted
    end
      
    self #returns self object
  end
  
  def self.create(name:, grade:)
    self.new(name, grade).save
  end
  
  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT *
      FROM students
      WHERE name = ?
    SQL
    
    row = DB[:conn].execute(sql, name).flatten
    self.new(row[1], row[2], row[0])
  end
  
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @album, @id)    
  end
end
