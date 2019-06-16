require_relative "../config/environment.rb"

class Student
attr_accessor :name, :grade
attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end #end the initialize method
#########################################
  def self.create_table
    sql = <<-Text
    CREATE TABLE IF NOT EXISTS students ( id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    Text
    DB[:conn].execute(sql)
  end #end the create table method
################################################
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS STUDENTS")
  end #end drop TABLE
#################################################
  def save
    if self.id
      self.update
    else
      sql="INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end #end the if/then
  end #end save
##################################################
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end #end the update method
##################################################
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end
###########################################
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end
##################################################
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end
end
