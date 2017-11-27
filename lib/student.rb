require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-sql
      create table if not exists students(
      id integer primary key,
      name text,
      grade integer
      )
    sql

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-sql
      drop table if exists students
    sql

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-sql
        insert into students(name, grade) values (?, ?)
      sql

      DB[:conn].execute(sql, self.name, self.grade)

      sql2 = <<-sql
        select last_insert_rowid() from students
      sql

      @id = DB[:conn].execute(sql2)[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = self.new(row[0], row[1], row[2])
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = <<-sql
      select * from students
      where name = ?
    sql

    DB[:conn].execute(sql, name).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    sql = <<-sql
      update students
      set name = ?,
      grade = ?
      where id = ?
    sql

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
