require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_accessor :id

  def initialize(id=nil, name, grade)
    @id = id 
    @name = name
    @grade = grade
  end 
  

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL
    DB[:conn].execute(sql)
  end 

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL
    DB[:conn].execute(sql)
  end 

  def save
    if @id

      student = DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id =  ?", @name, @grade, @id)

    else  

      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
      SQL
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT * FROM students WHERE name = ?", @name).flatten[0]

    end
  end

  def self.create(name, grade)
    DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", name, grade)
    student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)
    self.new(student[0], student[1], student[2])
  end 

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end 

  def self.find_by_name(name)
    student = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).flatten
    if student.empty?
    else

      self.new(student[0], student[1], student[2])

    end
  end 

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", @name, @grade, @id)
  end 
end
