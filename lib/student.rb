require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def initialize(name, grade, id=nil)
    self.name = name
    self.grade = grade
    self.id = id
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
          INSERT INTO students (name, grade) VALUES (?, ?)
          SQL
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    self.new(name, grade). tap do |student|
      student.save
    end
  end

  def self.new_from_db(row)
    self.new(nil, nil).tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.find_by_name(name)
    self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0])
  end

end
