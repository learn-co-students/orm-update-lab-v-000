require_relative "../config/environment.rb"


class Student

  attr_accessor :name, :grade, :id

  def initialize(id=nil, name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
      SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
        self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?);
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

def update
  sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.grade, self.id)
end

def self.create(name, grade)
  student = Student.new(id=nil,name, grade)
  student.save
end

def self.new_from_db(row)
  student = Student.new(row[1], row[2])
  student.id = row[0]
  student
end

def self.find_by_name(name)
  sql = "SELECT * FROM students WHERE name = ?"
  name_row = DB[:conn].execute(sql, name)[0]
  Student.new_from_db(name_row)
end

end
