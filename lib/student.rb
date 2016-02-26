require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name,grade,id=nil)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name text, grade number)
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
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    # attributes.each {|key, value| self.send(("#{key}="), value)}
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(array)
    id = array[0]
    name = array[1]
    grade = array[2]
    student = self.new(name, grade, id)
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL 
      SELECT * 
      FROM students 
      WHERE name = ?
      LIMIT 1
      SQL

      DB[:conn].execute(sql, name).map do |student|
        self.new_from_db(student)
      end.first
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql,self.name, self.grade, self.id)
  end
end
