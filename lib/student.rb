require_relative "../config/environment.rb"

class Student
attr_accessor :name, :grade
attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
def initialize(id=nil,name,grade)
@id = id
@name = name
@grade = grade
end

def self.create_table
sql = <<-SQL
CREATE TABLE IF NOT EXISTS students(
  id INTEGER private key,
  name TEXT,
  grade INTEGER
)
SQL
DB[:conn].execute(sql)
end

def self.drop_table
DB[:conn].execute("DROP TABLE students")
end

def save

if self.id != nil
  self.update
else
sql = <<-SQL
INSERT INTO students (name,grade)
VALUES (?,?);
SQL

DB[:conn].execute(sql,@name,@grade)
@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

end
end

def update
sql = <<-SQL
UPDATE students
SET name = ?, grade = ?
WHERE id = ?;
SQL

DB[:conn].execute(sql,@name,@grade,@id)
end

def self.create(name, grade)
new_student = Student.new(name,grade)
new_student.save
new_student
end

def self.new_from_db(row)
Student.new(row[0],row[1],row[2])
end

def self.find_by_name(name)
sql = <<-SQL
SELECT *
FROM students
WHERE name = ?;
SQL

self.new_from_db(DB[:conn].execute(sql,name).flatten)
end

end
