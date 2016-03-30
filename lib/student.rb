require_relative "../config/environment.rb"

class Student
  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end
 
  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
  end

  def save
    save_student_sql = "INSERT INTO students (name, grade) VALUES (?, ?);"
    find_student_id_sql = "SELECT id FROM students WHERE name = ? LIMIT 1;"

    DB[:conn].execute(save_student_sql, self.name, self.grade)
    @id = DB[:conn].execute(find_student_id_sql, self.name).flatten[0]
  end

  def self.create(attributes)
    student = Student.new(nil, nil)
    attributes.each { |attr, value| student.send("#{attr}=", value) }
    student.save
  end

  def self.new_from_db(info)
    student = Student.new(info[1], info[2], info[0])    
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1;"

    student_info = DB[:conn].execute(sql, name).flatten
    Student.new_from_db(student_info)
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
end
