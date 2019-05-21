require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students;")
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT * FROM students ORDER BY id DESC LIMIT 1")[0][0]
    end
  end

  def self.create(name, grade)
    x = self.new(name, grade)
    x.save
    x
  end

  def self.new_from_db(row)
    x = self.new(row[1], row[2], row[0])
    x
  end

  def self.find_by_name(nname)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    named = DB[:conn].execute(sql, nname).flatten

    x = self.new_from_db(named)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
