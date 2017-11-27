require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id 

  def initialize(id = nil, name, grade)
      @id = id
      @name = name 
      @grade = grade
  end

  def save
    if self.id != nil
      sql = <<-SQL
        UPDATE students
        SET name = ?, grade = ?
        WHERE id = ?;
      SQL
      DB[:conn].execute(sql, @name, @grade, @id)
    else
      sql = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?);
      SQL
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0] 
    end
  end

  def update 
    self.save
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end
  
  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students;");
  end
end
