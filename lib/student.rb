require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
   sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

   def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
   end

  def self.new_from_db(row)
      new_song = self.new(row[1],row[2],row[0])  # self.new is the same as running Song.new
      new_song.id = row[0]
      new_song.name =  row[1]
      new_song.grade = row[2]
      new_song  # return the newly created instance
    end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
end
