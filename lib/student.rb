require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  def self.create_table
    new_table = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
      SQL
      DB[:conn].execute(new_table)
  end
  def self.drop_table
    drop = <<-SQL
      DROP TABLE students
      SQL
      DB[:conn].execute(drop)
  end
  def save
    save_student = <<-SQL
      INSERT INTO students (name, grade) values (?, ?)
      SQL
      DB[:conn].execute(save_student, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end
  def self.new_from_db(arr)
    id = arr[0]
    name = arr[1]
    grade = arr[2]
    self.new(id, name, grade)
  end
  def self.find_by_name(name)
    find = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(find, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  def update
    update = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
      DB[:conn].execute(update, self.name, self.grade, self.id)
  end
end
