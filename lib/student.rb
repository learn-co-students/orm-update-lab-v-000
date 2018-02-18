require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name text,
        grade INTEGER
      )
      SQL

      DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    # saves an instance of the Student class to the database and then sets the given studnets id attribute
    # updates a record if called on an object that is already persisted
    if self.id
      sql = "UPDATE students SET name = ?, grade = ? Where id = ?"
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    # creates a student object with name and grade attributes
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    # creates an instance with corresponding attributes values
    name = row[1]
    grade = row[2]
    new_student = self.new(name, grade)
    new_student.id = row[0]
    new_student.name = name
    new_student.grade = grade
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? Where id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
