require 'pry'
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


  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end


  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)
  end


  def self.find_by_name(name, id) 
    sql = "SELECT *
    FROM students
    WHERE name = ?"
    row = DB[:conn].execute(sql, name)
    self.find_by_name

  end


  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
#binding.pry
    DB[:conn].execute(sql, self.name, self.grade, self.id)

    # This method updates the database row mapped to the given `Student` instance.
    # describe '#update' do
      #it 'updates the record associated with a given instance' do
        #josh.save
        #josh.name = "Josh Jr."
        #josh.update
        #josh_jr = Student.find_by_name("Josh Jr.")
        #expect(josh_jr.id).to eq(josh.id)

    end

end
