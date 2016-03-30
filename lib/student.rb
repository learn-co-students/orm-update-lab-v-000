require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        ID INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT)
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = <<-SQL
        DROP TABLE students
      SQL

      DB[:conn].execute(sql)
  end

  def self.create(attributes_hash)
    student = Student.new(attributes_hash[:name], attributes_hash[:grade])
    student.save
    student
  end

  def self.new_from_db(row)
    Student.new(row[1],row[2],row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students where name = ?
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.id)

  end 
end
