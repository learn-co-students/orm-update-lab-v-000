require_relative "../config/environment.rb"
require 'pry'
class Student
	attr_accessor :name, :grade
	attr_reader :id	
	def initialize(id=nil,name,grade)
		@id = id
		@name = name
		@grade = grade
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
    end
  end

  def update
	sql = <<-SQL 
		UPDATE students SET name = ?, grade = ? WHERE id =?
		SQL
		DB[:conn].execute(sql,self.name,self.grade,self.id) 
  end

	#class methods
	def self.create_table
		sql = <<-SQL
		CREATE TABLE IF NOT EXISTS students(
		id INTEGER PRYMARY KEY,
		name TEXT,
		grade INTEGER);
		SQL
		DB[:conn].execute(sql)
	end 

	def self.drop_table
		sql = <<-SQL
		DROP TABLE IF EXISTS students
		SQL
		DB[:conn].execute(sql)
	end

	def self.create(name,grade)
		student = self.new(name,grade)
		name = student.name
		grade = student.grade
		sql = <<-SQL 
		INSERT INTO students (name,grade) VALUES(?,?)
		SQL

		DB[:conn].execute(sql,student.name,student.grade)
	end 

	def self.new_from_db(row)
		id = row[0]
		name = row[1]
		grade = row[2]
		self.new(id,name,grade)
	end 

	def self.find_by_name(name)
		sql = <<-SQL
		SELECT *
		FROM students
		Where name = ?
		LIMIT 1
		SQL

		DB[:conn].execute(sql,name).map do |row|
			self.new_from_db(row)
		end.first
	end 


end
