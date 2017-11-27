require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader   :id

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute sql
  end

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute sql
  end

  def self.create(name, grade)
    student = new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    new row[0], row[1], row[2]
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? LIMIT 1
    SQL

    student = DB[:conn].execute(sql, name).first
    new_from_db student
  end

  def initialize(id = nil, name, grade)
    @name  = name
    @grade = grade
    @id    = id
  end

  def save
    if id
      update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute sql, name, grade
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute sql, name, grade, id
  end
end
