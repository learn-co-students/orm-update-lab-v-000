require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if @id
      update
    else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)",@name ,@grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", @name, @grade, @id)
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    DB[:conn].execute("INSERT INTO students (id, name, grade) VALUES (?, ?, ?)", row[0], row[1], row[2])
    student = self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    blah = DB[:conn].execute("SELECT * FROM students WHERE students.name = ?", name).first
    self.new(blah[0], blah[1], blah[2])
  end
end
