require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade, :id

  def initialize(name=nil,grade=nil,id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,name TEXT, album TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO students (name,grade) VALUES (?,?);"
    DB[:conn].execute(sql,self.name,self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create(student_hash)
    student = Student.new
    student_hash.each do |key,value| 
      student.send(("#{key}="),value)
    end
    student.save
  end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name=(?) LIMIT 1;"
    array = DB[:conn].execute(sql,name)[0]
    Student.new(array[1],array[2],array[0])
  end

  def update
    sql = "UPDATE students SET name=(?),grade=(?) WHERE id=(?);"
    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end
end
