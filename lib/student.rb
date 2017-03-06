require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
  	@id = id
  	@name = name
  	@grade = grade
  end

  def self.create_table
  	DB[:conn].execute('CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);')
  end

  def self.drop_table
  	DB[:conn].execute('DROP TABLE students')
  end

  def save
  	if self.id === nil
  		DB[:conn].execute('INSERT INTO students (name, grade) VALUES (?,?)',self.name, self.grade)
  		@id=DB[:conn].execute('SELECT MAX(id) FROM students;')[0][0]
  	else
  		DB[:conn].execute('UPDATE students SET name = ? WHERE id = ?',self.name, self.id)
      DB[:conn].execute('UPDATE students SET grade = ? WHERE id = ?', self.grade,self.id)
    end
  end

  def self.create(name,grade)
    self.new(name,grade).save
  end

  def self.new_from_db(row)
    self.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    self.new_from_db(DB[:conn].execute('SELECT * FROM students WHERE name = ?', name)[0])
  end

  def update
    DB[:conn].execute('UPDATE students SET name = ? WHERE id = ?',self.name, self.id)
    DB[:conn].execute('UPDATE students SET grade = ? WHERE id = ?', self.grade,self.id)
  end
end
