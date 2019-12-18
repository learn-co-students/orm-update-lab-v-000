require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end
  
  def self.create_table
    sql = <<-SQL
      create table if not exists students (
        id integer primary key
        , name text 
        , grade integer
      )
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    DB[:conn].execute("drop table students")
  end
  
  def save
    if @id
      self.update
    else
      sql = <<-SQL
        insert into students (name, grade)
        values (?, ?)
      SQL
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
    end
  end
  
  def update
    sql = <<-SQL
      update students
      set name = ?, grade = ?
      where id = ?
    SQL
    DB[:conn].execute(sql, @name, @grade, @id)
  end
  
  def self.create(name, grade)
    s = self.new(name, grade)
    s.save
    s
  end
  
  def self.new_from_db(list)
    s = self.new(list[0], list[1], list[2])
    s
  end
  
  def self.find_by_name(name)
    result = DB[:conn].execute("select * from students where name = ?", name)[0]
    self.new(result[0], result[1], result[2])
  end

end
