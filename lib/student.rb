require_relative "../config/environment.rb"

class Student
  attr_accessor:name,:grade
  attr_reader:id

 
  def initialize(id=nil,name,grade)
    @id = id
    @name = name
    @grade= grade
  end

  def self.create_table
    sql = <<-sql
        Create table if not exists students(
          id integer primary key,
          name text,
          grade text)
        sql
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "drop table if exists students"
    DB[:conn].execute(sql)
  end

  def save
    sql= <<-sql 
        insert into students(name,grade)
        values(?,?)
        sql
    DB[:conn].execute(sql,self.name,self.grade)
    @id= DB[:conn].execute("select last_insert_rowid() from students")[0][0]
  end

  def self.create(name:,grade:)
    student= Student.new(name,grade)
    student.save
  end
  
  def self.new_from_db(row)
    Student.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    sql = <<-sql
          select * from students
          where name = ? limit 1
           sql
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = <<-sql 
        update students set name=?,grade=? where id=?
        sql
    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end

  

end
