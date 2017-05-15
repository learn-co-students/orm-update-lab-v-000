require_relative "../config/environment.rb"

class Student
	attr_accessor :name, :grade
	attr_reader :id

	def initialize(id = nil, name, grade)
		@id = id
		@name = name
		@grade = grade
	end

	def self.create_table
		sql = <<-SQL
		  CREATE TABLE IF NOT EXISTS students (
		 	id INTEGER PRIMARY KEY,
		    name TEXT,
		    grade TEXT
		  );
		SQL

		DB[:conn].execute(sql)
	end

	def self.drop_table
		DB[:conn].execute("DROP TABLE IF EXISTS students")
	end

	def save
	  if self.id  # check if record already exists, to prevent duplicate insertions
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

	def self.create(new_name, new_grade)
		new_student = Student.new(new_name, new_grade)
		new_student.save
		new_student
	end

	def self.find_by_name(name)
		sql = "SELECT * FROM students WHERE name = ?"
		row = DB[:conn].execute(sql, name)[0]

		self.new_from_db(row)
	end

	def self.new_from_db(row)
		Student.new(row[0], row[1], row[2])
	end

	def update
		sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?" # update all attributes based on the unique ID
		DB[:conn].execute(sql, self.name, self.grade, self.id)
	end

end
