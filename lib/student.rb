require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
            SELECT * FROM students
          SQL
    all = DB[:conn].execute(sql)
    all.collect do |array|
      Student.new.tap do |s|
        s.id = array[0]
        s.name = array[1]
        s.grade = array[2]
      end
    end
  end

  def initialize(name=nil, grade=nil, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.find_by_name(name)
    sql = <<-SQL
            SELECT * FROM students
            WHERE students.name = name
          SQL
    student_info = DB[:conn].execute(sql)[0]
    return Student.new(
      name = student_info[1],
      grade = student_info[2],
      id = student_info[0]
    )
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    new_student = self.new  # self.new is the same as running Song.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
