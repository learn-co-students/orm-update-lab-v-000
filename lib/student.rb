require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

 def initialize(id = nil,name, grade)
    @name = name
    @grade = grade
    @id = id
 end

 def self.create_table
  sql = <<-SQL 
  CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER) 
  SQL
  DB[:conn].execute(sql)
 end

 def self.drop_table
      DB[:conn].execute("DROP TABLE IF EXISTS students")
 end
 
 def save
  sql = <<-SQL
  INSERT INTO students (name,grade) VALUES (?,?)
  SQL
  DB[:conn].execute(sql,self.name,self.grade)
  @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
 end

 def self.create(name:, grade:)
  student = Student.new(name,grade)
  student.save
 end

 def self.new_from_db(row)
  student = Student.new(row[0],row[1],row[2])
 end

 def self.find_by_name(name)
  sql = <<-SQL
  SELECT * FROM students
  WHERE ? = students.name LIMIT 1
  SQL
  result = DB[:conn].execute(sql,name)[0]
  student = Student.new(result[0],result[1],result[2])
 end

 def update
  sql = <<-SQL
  UPDATE students SET name = ?, grade = ?
    WHERE students.id = ?
  SQL
  DB[:conn].execute(sql,@name,@grade,@id)
 end 
 
end
