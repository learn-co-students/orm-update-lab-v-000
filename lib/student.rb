require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_accessor :id

  def initialize(name, grade, id=nil)
    self.name = name
    self.grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY key,
        name TEXT,
        grade INTEGER
      )
      SQL

      DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
        SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() from students")[0][0]
    end
  end

  def self.create(name, grade)
    self.new(name, grade).tap{|s| s.save}
  end

  def self.new_from_db(student_array)
    self.new(student_array[1], student_array[2], student_array[0])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    student_array = DB[:conn].execute(sql, name).flatten
    #binding.pry
    self.new_from_db(student_array)
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
