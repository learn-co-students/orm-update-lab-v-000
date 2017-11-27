#####attributes                                                                                                                                                                                                 
#has a name and a grade                                                                                                                                                                                   
# has an id that defaults to `nil` on initialization                                                                                                                                                       
#####create_table                                                                                                                                                                                              
#creates the students table in the database                                                                                                                                                               
#####drop_table                                                                                                                                                                                                
#drops the students table from the database                                                                                                                                                               
#####save                                                                                                                                                                                                      
#saves an instance of the Student class to the database and then sets the given students `id` attribute                                                                                                   
#updates a record if called on an object that is already persisted                                                                                                                                        
#####create                                                                                                                                                                                                    
#creates a student object with name and grade attributes                                                                                                                                                  
#####new_from_db                                                                                                                                                                                               
#creates an instance with corresponding attribute values 
#####find_by_name                                                                                                                                                                                              
#returns an instance of student that matches the name from the DB                                                                                                                                         
#####update                                                                                                                                                                                                    
#updates the record associated with a given instance

require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
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
    sql = <<-SQL
    DROP TABLE IF EXISTS students 
    SQL
    DB[:conn].execute(sql)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

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
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

end
