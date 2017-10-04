require_relative "../config/environment.rb"
require 'pry'

class Student
	attr_accessor :name, :grade
	attr_reader :id

	def initialize(id = nil, name, grade)
		@id = id
		@name = name
		@grade = grade
	end
#-------- CLASS METHODS -----------------------
	def self.create_table
		sql = <<-SQL 
			CREATE TABLE students (
			id INTEGER PRIMARY KEY,
			name TEXT,
			grade TEXT)
		SQL
		DB[:conn].execute(sql)
	end

	def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  	end

  	def self.create (name, grade)
  		new_student = self.new(name, grade)
  		new_student.save
  		new_student
  	end

  	def self.new_from_db(array)
  		new_obj = self.new(array[0], array[1], array[2])
  		new_obj
  	end

  	def self.find_by_name(student_name)
  		sql = <<-SQL
  		SELECT * FROM students
  		WHERE name = ?
  		SQL
  		
  		row = DB[:conn].execute(sql, student_name).flatten
  		
  		new_student = self.new_from_db(row)
  		new_student
  	end

#--------- Instance Methods ----------------------
  	def save
  		if self.id
  			self.update
  		else
	  		sql = <<-SQL 
	  		INSERT INTO students (name, grade) VALUES (?, ?)
	  		SQL

	  		DB[:conn].execute(sql, self.name, self.grade)

	  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  		end
  	end

  	def update
  		sql = <<-SQL
  		UPDATE students set name = ?, grade = ? WHERE id = ?
  		SQL

  		DB[:conn].execute(sql, self.name, self.grade, self.id)
  	end




  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
end
