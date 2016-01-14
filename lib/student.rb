require_relative "../config/environment.rb"

class Student
	attr_accessor :name, :grade
	attr_reader :id

	def initialize(name, grade, id=nil)
		@name=name
		@grade=grade
		@id=id
	end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  def self.create_table
  	sql = "CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, name TEXT, GRADE INTEGER)"
  	DB[:conn].execute(sql)
  end

  def save
  	if id
  		self.update
  	else
  		sql = "INSERT INTO students(name, grade) VALUES(?,?)"
  		DB[:conn].execute(sql, @name, @grade)
  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  	end
  end

  def self.drop_table
  	DB[:conn].execute("DROP TABLE students")
  end

  def self.create(name:, grade:, id:nil)
  	new_student = self.new(name, grade)
  	new_student.save
  	new_student
  end

  def self.new_from_db(row)
  	self.new(row[1],row[2], row[0])
  end

  def self.find_by_name(name)
  	row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0]
  	self.new_from_db(row)
  end

  def update
  	sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  	DB[:conn].execute(sql, @name, @grade, @id)
  end

end
