require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
  	@id=id
  	@name=name
  	@grade=grade
  end
  
  def self.create_table
  	sql = <<-SQL
  		CREATE TABLE IF NOT EXISTS students (
  			id INTEGER PRIMARY KEY,
  			name TEXT,
  			grade INTEGER)
  		SQL
  	DB[:conn].execute(sql)
  end
 
  def self.drop_table
  	sql=<<-SQL
  		DROP TABLE students
  		SQL
  	DB[:conn].execute(sql)
  end
  
  def save
  	if self.id.nil?
  		sql=<<-SQL
  			INSERT INTO students (name, grade) VALUES
  				(?, ?)
  			SQL
  		DB[:conn].execute(sql, self.name, self.grade)
  		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  	else
  		self.update
  	end
  end
  
  def self.create(name:, grade:, id:nil)
  	student = Student.new(id, name, grade)
  	student.save
  	student
  end
  
  def self.new_from_db(row)
  	student = Student.new(row[0], row[1], row[2])
  	student
  end
  	
  def update
  	sql=<<-SQL
  		UPDATE students SET name=?, grade=? WHERE id=?
  		SQL
  	DB[:conn].execute(sql,self.name, self.grade, self.id)  	
   end
   
  def self.find_by_name(name)
  	sql=<<-SQL
  		SELECT * FROM students WHERE name = ?
  		SQL
  	all = DB[:conn].execute(sql, name)
  	all.map { |x| Student.new_from_db(x) }.first 
  end
 
end
