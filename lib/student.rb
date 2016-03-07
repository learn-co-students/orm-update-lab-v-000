require_relative "../config/environment.rb"

class Student

attr_accessor :id, :name, :grade

  def initialize (id=nil, name, grade)
    self.id = id
    self.name = name
    self.grade = grade
  end

  def self.create_table
    sql = (<<-SQL)
          CREATE TABLE IF NOT EXISTS students(
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
            )
          SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if self.id
      self.update
    else
      sql = (<<-SQL)
          INSERT INTO students (name, grade)
          VALUES (?, ?)
        SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

    def update
      sql = (<<-SQL)
            UPDATE students
            SET name = ?, grade = ?
            WHERE id = ?
          SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

    def self.find_by_name(name)
      student_info = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).first

      student = Student.new(student_info[0], student_info[1], student_info[2])
      student
    end

    def self.create (name, grade)
      student = self.new(nil, name, grade)
      student.save
      student
    end
    
    def self.new_from_db(array)
      student = self.new(array[0], array[1], array[2])
    end

end
