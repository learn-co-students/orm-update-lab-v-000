require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade

  end
  # Remember, you can access your database connection anywhere in this class
  #with DB[:conn]

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


  def save
      if self.id
        self.update
      else
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
#binding.pry
      end
  end


  def create
  end

  def new_from_db
  end

  def find_by_name
  end

  def update
  end

end
