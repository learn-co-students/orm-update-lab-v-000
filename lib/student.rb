require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    self.new_from_db(DB[:conn].execute(sql, name).first)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def initialize(name, grade, id = nil)
    self.name, self.grade, @id = name, grade, id
  end

  def save
    unless self.id
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").first.first
    else
      self.update
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
