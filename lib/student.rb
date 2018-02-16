require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    "CREATE TABLE students"
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
