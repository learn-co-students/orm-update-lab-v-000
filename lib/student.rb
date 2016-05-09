require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name,grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql ="CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,name TEXT,grade TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = "DROP TABLE IF EXISTS students"
      DB[:conn].execute(sql)
  end


 def save
      sql = "INSERT INTO students (name, grade) VALUES (?,?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

#    def self.create(name:, grade:)
#         new_student = Student.new(name, grade)
#         new_student.save
#         new_student
#     end

    def self.create(name,grade)
       new_student = Student.new(name, grade)
         new_student.save
         new_student
    end

  def self.new_from_db(row)
      new_student = self.new(row[0],row[1],row[2])  # self.new is the same as running Song.new
      new_student  # return the newly created instance
end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"

    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

   def update
    sql = "UPDATE students SET id = ?, name = ?"
    DB[:conn].execute(sql, self.id,self.name)
  end

end
