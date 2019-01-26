require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id = nil, name, grade)
    @id = id 
    @name = name
    @grade = grade
  end 

  def self.create_table
    sql =<<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql =<<-SQL
      DROP TABLE students
    SQL
    
    DB[:conn].execute(sql)
  end 
  
  def save
    if self.id != nil
      self.update
    else 
      sql =<<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    end
  end 

    def update
      sql =<<-SQL
        UPDATE students
        SET name = ?, grade = ?
        WHERE id = ?
      SQL
      
     DB[:conn].execute(sql,self.name, self.grade, self.id)
    end 
    
    def self.create(name, grade)
      student = Student.new(name, grade) 
      student.save
      student
    end 
  
    def self.new_from_db(student) 
      id = student[0]
      name = student[1]
      grade = student[2]
  
      self.create(name, grade)
    end 
    
    def self.find_by_name(name)
      sql =<<-SQL
        SELECT * FROM students
        WHERE name = ?
      SQL
      
      result = DB[:conn].execute(sql, name)[0]
      self.new(result[0], result[1], result[2])
      
    end 

end
