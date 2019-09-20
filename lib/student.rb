require_relative "../config/environment.rb"

#DB[:conn] is our constant for accessing DB

class Student

    attr_accessor :name, :grade
    attr_reader :id
    

    def initialize( id = nil, name, grade )
      @id = id
      @name = name
      @grade = grade
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
      
      # Simply creates our students table and executes it by passing the variable sql
      # through DB[:conn].execute(sql)
    end
    
    
    def self.drop_table
      sql = <<-SQL
      DROP TABLE students
      SQL
      
      DB[:conn].execute(sql)
      # Drops the table through the passing of variable SQL
      # DB[:conn].execute(sql)
    end
    
    
    def save
      if self.id
        self.update
      end
        
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      
      # To make sure don't get duplicates when we save, we check to see if the ID exist.  If it does
      # We call the updat method to simply update, rather than make a new row
      # Other than that, we save our new columns, through a "picture" of our object into DB[:conn]
      # The last line is assigning a unique id attribute everytime they are saved
      # This is why we can refactor or update method to update VIA ID, and not the other attributes
    end
    
    
    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
      student
    end
    
    def self.new_from_db(row)
        Student.new(row[0], row[1], row[2])
    endlear
      
    
    
    def self.find_by_name(name)
      sql = "SELECT * FROM students WHERE name = ?"
      result = DB[:conn].execute(sql, name)[0]
      Student.new(result[0], result[1], result[2])
      
      #Regardless of what we are looking for, we still always want to return a new 
      #object.  In this case, we want to find it by name.  So, we sanitize it to make sure
      #we are inputting the name value and not grade or ID.  We could easily do id like this if 
      #we wanted too
      # ------------------------------------------
      # sql = "SELECT * FROM students WHERE id = ?"
      # result = DB[:conn].execute(sql, id)[0]
      # Student.new(result[0], result[1], result[2]
      # ------------------------------------------
    end
    
      
    def update
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end


end
