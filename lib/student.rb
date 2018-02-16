require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id PRIMARY KEY INTEGER,
    name TEXT,
    grade INTEGER
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
  end

  def save
  end

  def create
  end

  def self.new_from_db
  end

  def self.find_by_name
  end

  def update
  end


end
