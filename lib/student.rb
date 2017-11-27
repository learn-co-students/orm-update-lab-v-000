require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id,:name,:grade

  def initialize(id=nil,name,grade)
    self.id = id
    self.name = name
    self.grade = grade
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

  def save
    if self.id != nil
      self.update
    else
      DB[:conn].execute("INSERT INTO students(name,grade) VALUES (?,?)",self.name,self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

  end

  def self.create(name,grade)
    new_student = self.new(name,grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    self.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    student_info = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1",name)
    self.new_from_db(student_info[0])
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?",self.name,self.grade,self.id)
  end

end
