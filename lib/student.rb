require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id
  @@all = []
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
  
  def self.create_table
    sql =  <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        grade TEXT
        )
    SQL
    
    DB[:conn].execute(sql) 
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    #@@all << self #save to the database
    if self.id  #could also use if self.id !=nil
      sql = <<-SQL 
        UPDATE students 
        SET name = ?, grade = ? 
        WHERE id = ?
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      #do this when id doesn't exist
      #first put it in the database
      sql = <<-SQL
        INSERT INTO students (name, grade) 
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      #get the id from the database
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]      
    end
  end
  
  def self.create(name, grade)
    Student.new(name, grade).save
  end
  
  def self.new_from_db(row)
    #Student.new(row[1], row[2], row[0]).save #doesn't work for some reason
    #reason is "undefined method 'id' for []:Array"
    id, name, grade = row[0], row[1], row[2]
    #new_id = row[0]
    #name = row[1]
    #grade = row[2]
    Student.new(name, grade, id) #don't need to use .save, plus it won't work
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    x = DB[:conn].execute(sql, name).collect do |row|
      self.new_from_db(row)
    end#.first #getting error if i'm not using .first, due to array/getting more than 1
    x[0] #the .first is a little hard to see, i like this way more
  end
  
  def update #instance method
    sql = <<-SQL 
        UPDATE students 
        SET name = ?, grade = ? 
        WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
