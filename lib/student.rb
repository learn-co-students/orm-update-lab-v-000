require_relative "../config/environment.rb"
require 'pry'
class Student
	attr_accessor :name, :grade 
	attr_reader :id

	def initialize(name, grade, id = nil)
		@name = name 
		@grade = grade 
		@id = id 
	end

	def self.create_table 
		sql = <<-SQL
			CREATE TABLE students (
			id INTEGER PRIMARY KEY,
			name TEXT,
			grade INTEGER)
		SQL

		DB[:conn].execute(sql)
	end

	def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
  	if self.id 
  		self.update 
  	else 
	  	sql = <<-SQL
	  		INSERT INTO students (name, grade) VALUES (?, ?)
	  	SQL

	  	DB[:conn].execute(sql, self.name, self.grade)

	  	@id = DB[:conn].execute("SELECT LAST_INSERT_ROWID()")[0][0]
	  end
  end

  def self.create(name, grade)
  	student = self.new(name, grade)
  	student.save 
  	student
  end

  def self.new_from_db(row)
  	self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
  	sql = "SELECT * FROM students WHERE name = ?"

  	student = DB[:conn].execute(sql, name)[0]
  	self.new(student[1], student[2], student[0])
  end

  def update 
  	sql = "UPDATE students SET name = ?, grade = ? WHERE ID = ?"

  	DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
