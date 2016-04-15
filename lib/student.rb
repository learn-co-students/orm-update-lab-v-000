require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  class << self
    def create_table
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS
          students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade INTEGER
          );
      SQL
      
      DB[:conn].execute(sql)
    end
    
    def drop_table
      sql = <<-SQL
        DROP TABLE students;
      SQL
      
      DB[:conn].execute(sql)
    end
    
    def create(name, grade)
      student = self.new(name, grade)
      student.save
    end
    
    def new_from_db(row)
      self.new(row[0], row[1], row[2])
    end
    
    def find_by_name(name)
      sql = <<-SQL
        SELECT id, name, grade
        FROM students
        WHERE name = ?;
      SQL
      
      student = DB[:conn].execute(sql, name).flatten
      new_from_db(student)
    end
  end
  
  def save
    insert = <<-SQL
      INSERT INTO
        students (name, grade)
      VALUES
        (?, ?);
    SQL
    
    DB[:conn].execute(insert, @name, @grade)
    
    get_id = <<-SQL
     SELECT id
     FROM students
     ORDER BY id
     DESC
     LIMIT 1;
    SQL
    
    @id = DB[:conn].execute(get_id)[0][0]
    
    return self
  end
 
  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?;
    SQL
   
    DB[:conn].execute(sql, @name, @grade, @id)
  end
 
end
