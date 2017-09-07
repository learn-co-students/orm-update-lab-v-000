require_relative "../config/environment.rb"

class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
  	@id = id
  	@name = name
  	@grade = grade
  end

  def self.create_table
  	sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	DB[:conn].execute("DROP TABLE students")
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

  def self.create(name, grade)
  	student = self.new(name, grade)
  	student.save
  end


  def self.new_from_db(row) ## this one was the problem: the self.new couldn't be called without arguments
  	new_student = self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
  	sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
  	DB[:conn].execute(sql, name).map do |row|
  		self.new_from_db(row)
  	end.first
  end

  def update
  	sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  	DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
