require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name, grade)
  	@id = id
  	@name = name
  	@grade = grade
  end

  def self.create_table
  	sql = <<-SQL
  		CREATE TABLE students(
  		id INTEGER PRIMARY KEY, 
  		name TEXT, 
  		grade TEXT
  		)
  		SQL
  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	sql = <<-SQL
  		DROP TABLE students
  		SQL
  	DB[:conn].execute(sql)
  end

  def save
  	if self.id
  		sql = <<-SQL
	  		UPDATE students 
	  		SET name = ?, grade = ?
	  		WHERE id = ?
	  		SQL
	  	DB[:conn].execute(sql, self.name, self.grade, self.id)
  	else
	  	sql = <<-SQL
	  		INSERT INTO students(name, grade) 
	  		VALUES (?, ?)
	  		SQL
	  	DB[:conn].execute(sql, self.name, self.grade)

	  	@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
	  end
  end

  def self.create(name, grade)
  	student = Student.new(name, grade)
  	student.save
  	student
  end

  def self.new_from_db(array)
  	student = Student.new(array[0], array[1], array[2])
  	student
  end

  def self.find_by_name(name)
  	sql = <<-SQL
  		SELECT * FROM students 
  		WHERE name = ?
  		SQL
  	student_array = DB[:conn].execute(sql, name)
  	student = Student.new_from_db(student_array[0])
  	student
  end

  def update
  	self.save
  end


end
