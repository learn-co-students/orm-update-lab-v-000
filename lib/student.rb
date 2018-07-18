require_relative "../config/environment.rb"

class Student

attr_accessor :name, :grade
attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(
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

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id != nil
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      the_id = "SELECT last_insert_rowid() FROM students"

      @id = DB[:conn].execute(the_id)[0][0]
    end
  end

  def self.create(name, grade)
    new = Student.new(name, grade)
    new.save
    new
  end

  def self.new_from_db(row)
    Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name)
    new_student = Student.new_from_db(row.flatten)
    new_student
  end

end
