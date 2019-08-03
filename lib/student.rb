require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  @@all = []

  def initialize(name, grade, id = nil)
    self.name, self.grade = name, grade
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
    SQL
    
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.create(name, grade)
    new_student = self.new(name, grade)
    new_student.save
    new_student
  end
  
  def self.new_from_db(row)
    self.create(row[1],row[2])
  end
  
  def self.find_by_name(name)
    student = @@all.detect {|student| student.name = name }
    if student
      student
    else
      sql = <<-SQL
        SELECT * 
        FROM students
        WHERE name = ?
      SQL
      
      self.new_from_db(DB[:conn].execute(sql, name).flatten)
    end
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
      
      @@all << self
    end
  end
  
  def update
    sql = <<-SQL
      UPDATE students 
      SET name = ?, grade = ?
      WHERE id = ?
    SQL
    
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
