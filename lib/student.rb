require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        GRADE INTEGER)
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
    if id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(attributes)
    id, name, grade = attributes
    Student.new(name, grade, id)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ? LIMIT 1
      SQL
    attributes = DB[:conn].execute(sql, name)[0]
    self.new_from_db(attributes)
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
      SQL
    DB[:conn].execute(sql, name, grade, self.id)
  end
 
end
