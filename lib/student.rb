require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
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

  def self.create(name, grade)
      self.new(name, grade).save
  end

  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?;
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO students
      (name, grade)
      VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].last_insert_row_id
    end
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?;
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id).flatten
  end
end
