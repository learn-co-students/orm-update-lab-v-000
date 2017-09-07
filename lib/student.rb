require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize( id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
          CREATE TABLE students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
          )
          SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = 'DROP TABLE students'
    DB[:conn].execute(sql)
  end

  def update
    sql = 'UPDATE students SET name = ?, grade = ? WHERE id = ?'
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      sql = 'INSERT INTO students (name, grade) VALUES (?,?)'
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    end
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.new_from_db(arr)
    new_student = self.new(arr[0], arr[1], arr[2])
    new_student.id = arr[0]
    new_student.name = arr[1]
    new_student.grade = arr[2]
    new_student
  end

def self.find_by_name(name)
  sql = 'SELECT * FROM students WHERE name = ? LIMIT 1'
  DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
end

end
