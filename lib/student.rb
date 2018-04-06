require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :id, :grade

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"

      DB[:conn].execute(sql, self.name, self.grade)
    end
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name, grade)
    students = self.new(name, grade)
    students.save
    students
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(row)
   self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
  SQL
  DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
  end.first
  end

end

