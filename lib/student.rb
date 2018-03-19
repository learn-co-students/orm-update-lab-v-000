require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  @@all = []

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
    @@all<<self
  end

  def self.all
    @@all
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
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if @id
      self.update
    else
      DB[:conn].execute("INSERT INTO students(id, name, grade) VALUES (?,?,?)",@id,@name,@grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name,@grade,@id)
  end

  def self.create(name,grade)
    student = self.new(name,grade)
    sql = "INSERT INTO students(id,name,grade) VALUES (?,?,?)"
    DB[:conn].execute(sql,student.id,student.name,student.grade)
  end

  def self.new_from_db(row)
    student = self.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first
    self.new_from_db(row)
  end

end
