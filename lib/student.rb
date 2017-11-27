require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade,id=nil)
    @id,@name, @grade = id, name, grade
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE students(id integer PRIMARY KEY, name text,grade text)")
  end

 def self.drop_table
   DB[:conn].execute("DROP TABLE students")
 end

 def save
   if self.id
     DB[:conn].execute("UPDATE students SET name = ?,grade = ? WHERE id = ?",self.name,self.grade,self.id)
   else
 DB[:conn].execute("INSERT INTO students (name,grade) VALUES(?,?)",self.name,self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
   end
 end

 def self.create(name,grade)
       Student.new(name,grade).save
 end

 def self.new_from_db(row)
     #binding.pry
     Student.new(row[1],row[2],row[0])
 end

 def self.find_by_name(name)
   row = DB[:conn].execute("SELECT * FROM students WHERE name = ?",name).flatten
   self.new_from_db(row)
end

def update
  DB[:conn].execute("UPDATE students SET id = ?,name = ?, grade = ?", self.id,self.name,self.grade)
end

end
