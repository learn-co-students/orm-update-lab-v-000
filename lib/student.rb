require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade 

  def initialize(id = nil, name, grade)
    @id = id 
    @name = name 
    @grade = grade
  end
  
  def self.create_table
    sql =  "CREATE TABLE students ( 
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          grade TEXT 
          )"
     DB[:conn].execute(sql)
  
  end 
  
end
