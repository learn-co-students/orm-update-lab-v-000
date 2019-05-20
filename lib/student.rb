require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

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
      grade TEXT)
      SQL
      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE students;'
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id )
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students(name, grade)
      VALUES (?,?)
      SQL
      DB[:conn].execute(sql,self.name, self.grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    end
  end

#This class method takes an argument of an array.
#When we call this method we will pass it the array that is the row returned from the database by the execution of a SQL query.
  def self.new_from_db(row)
    #We can anticipate that this array will contain three elements in this order: the id, name and grade of a student.
    id = row[0]
    name = row[1]
    grade = row[2]
    #The .new_from_db method uses these three array elements to create a new Student object with these attributes.
    student = self.new(id, name, grade)
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end



end
