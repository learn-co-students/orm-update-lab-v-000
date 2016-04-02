require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :id, :name, :grade

  def initialize (id = nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = "create table if not exists students (id integer primary key, name text, grade text)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "drop table students"
    DB[:conn].execute(sql)
  end

  def save
    sql = "insert into students (name, grade) values (?, ?)"
    DB[:conn].execute(sql, @name, @grade)
    @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
  end
 
  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = "select * from students where name = ?"
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end

  def update
    sql = "update students set name = ?, grade = ? where id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
