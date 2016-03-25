require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
#///CLASS METHODS///#
  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(name,grade)
    student.save
  end

  def self.new_from_db(row)
    self.new(row[1],row[2],row[0])
  end
  
  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    self.new_from_db(DB[:conn].execute(sql,name)[0])
  end

#///INSTANCE METHODS///#
  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?,?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      self
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql,self.name,self.grade, self.id)
  end

end
