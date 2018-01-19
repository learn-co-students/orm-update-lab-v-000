require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name, @grade, @id = name, grade, id
  end

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end

  def self.create(name, grade, id = nil)
    Student.new(name, grade, id).tap{|student| student.save}
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save

    if self.id

    else
      sql = <<-SQL
      INSERT INTO students
      (name, grade)
      VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update

    sql = <<-SQL
    UPDATE students
    SET
    name = ?,
    grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.find_by_name(name)

    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map{|row| Student.new_from_db(row)}

end
