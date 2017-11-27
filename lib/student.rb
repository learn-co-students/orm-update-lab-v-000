require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  #attributes and variables
  attr_accessor :id, :name, :grade


  #initialize
  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end


  #class methods
  def self.create_table
    sql = <<-sql
      CREATE TABLE
      IF NOT EXISTS
      students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    sql

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-sql
      DROP TABLE
      students;
    sql

    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    new_student = self.new(row[0], row[1], row[2])
    new_student
  end

  def self.find_by_name(name)
    sql = <<-sql
      SELECT *
      FROM
      students
      WHERE
      name = ?;
    sql

    DB[:conn].execute(sql, name).map {|row| self.new_from_db(row)}.first
  end

  #instance methods
  def save
    sql = <<-sql
      INSERT INTO
      students
      (name, grade)
      VALUES
      (?,?);
    sql

    id_pull = <<-sql
      SELECT
      last_insert_rowid()
      FROM
      students;
    sql

    if self.id
      self.update
    else
      DB[:conn].execute(sql, self.name, self.grade)

      self.id = DB[:conn].execute(id_pull)[0][0]
    end
  end

  def update
    sql = <<-sql
      UPDATE
      students
      SET
      name = ?, grade = ?
      WHERE id = ?;
    sql

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
