require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute(<<-SQL)
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
  end

  def self.drop_table
    DB[:conn].execute(<<-SQL)
      DROP TABLE IF EXISTS students;
    SQL
  end

  def save
    if self.id
      self.update
    else
      DB[:conn].execute(<<-SQL, self.name, self.grade)
        INSERT INTO students (name, grade)
        VALUES (?, ?);
      SQL
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
    end
  end

  def self.create(name, grade)
    self.new(name, grade).tap{|new_student| new_student.save}
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    student = DB[:conn].execute(<<-SQL, name).first
      SELECT *
      FROM students
      WHERE students.name = ?;
    SQL

    self.new_from_db(student)
  end

  def update
    DB[:conn].execute(<<-SQL, self.name, self.grade, self.id)
      UPDATE students SET name = ?, grade = ? WHERE id = ?;
    SQL
  end

end
