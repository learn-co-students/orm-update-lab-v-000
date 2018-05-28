require_relative "../config/environment.rb"
require 'pry'

class Student
	attr_accessor :name, :grade
	attr_reader :id

	def initialize(id =nil, name, grade)
			@id = id
			@name = name
			@grade = grade
	end

	def self.create_table
		sql = <<-SQL
		CREATE TABLE students (
			id INTEGER PRIMARY KEY,
			name TEXT,
			grade INTEGER
		)
		SQL
		DB[:conn].execute(sql)
	end

	def self.drop_table
		sql = "DROP TABLE students"
		DB[:conn].execute(sql)
	end

	def save
		#saves an instance of the Student class to the database
		# and then sets the given students `id` attribute
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
		#creates a student object with name and grade attributes
		student = Student.new(name, grade)
		student.name = name
		student.grade = grade
		student.save
		student
	end

	def self.new_from_db(student_row)
		#creates an instance with corresponding attribute values
		student = Student.new(student_row[0], student_row[1], student_row[2])
		#binding.pry
	end

	def self.find_by_name(name)
		#returns an instance of student that matches the name from the DB
		sql = "SELECT * FROM students WHERE name = ?"
		student = (DB[:conn].execute(sql, name)).flatten
		student = Student.new(student[0], student[1], student[2])
	end

	def update
		sql = "UPDATE students SET name= ?, grade = ? WHERE id = ? "
		DB[:conn].execute(sql, self.name, self.grade, self.id)
	end
end
