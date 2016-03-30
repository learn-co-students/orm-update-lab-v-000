require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    self.name = name
    self.grade = grade
    @id = id
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.all
    sql = <<-SQL 
    SELECT * FROM students;
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL 
    SELECT * FROM students WHERE name = ?
    LIMIT 1;
    SQL
   DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
    #result = DB[:conn].execute(sql, name)[0]
    #Song.new(result[0], result[1], result[2])
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

  def update
    sql = <<-SQL 
      UPDATE students
      SET name = ?, grade = ? 
      WHERE id = ?;
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
