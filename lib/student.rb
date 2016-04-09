class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
      SQL
      
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?;"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new(row[0], row[1], row[2])
    new_student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? 
    SQL
 
    result = DB[:conn].execute(sql, name)[0]
    Student.new(result[0], result[1], result[2])
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(limit)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql, limit)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    self.new_from_db(DB[:conn].execute(sql)[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql, grade)
  end
end
