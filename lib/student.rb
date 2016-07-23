require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
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
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end

  def save
    if id
      update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end

  def self.new_from_db(row)
    student = Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = (?) LIMIT 1;"
    new_from_db(DB[:conn].execute(sql, name).first)
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ?
    WHERE id = ?;
    SQL
    DB[:conn].execute(sql, name, grade, id)
  end
end
