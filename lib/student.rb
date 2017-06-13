require_relative "../config/environment.rb"
require "pry"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql_query = <<-SQL
      CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT);
                  SQL
    DB[:conn].execute(sql_query)
  end
  def self.drop_table
    sql_query = <<-SQL
      DROP TABLE students
                  SQL
    DB[:conn].execute(sql_query)
  end
  def save
    if @id == nil
      sql_query = <<-SQL
        INSERT INTO students(name, grade) VALUES(?, ?)
                    SQL
      DB[:conn].execute(sql_query, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten.first
    else
      update
    end
    return self
  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end

  def self.new_from_db(row)
    Student.new(row[1],row[2],row[0])
  end
  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name).flatten
    new_from_db(row)
  end
  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", @name, @grade, @id)
  end
end
