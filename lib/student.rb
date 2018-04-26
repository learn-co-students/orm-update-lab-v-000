require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      create table students (
        id integer primary key,
        name text,
        grade integer
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("drop table students")
  end

  def save
    if self.id.nil?
      sql = <<-SQL
      insert into students (name, grade)
      values (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
    else
      update
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = self.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      select * from students
      where name = ?
    SQL

    self.new_from_db(DB[:conn].execute(sql, name).flatten)
  end

  def update
    sql = <<-SQL
      update students
      set name = ?, grade = ?
      where id = ?
    SQL

    DB[:conn].execute(sql, @name, @grade, @id)
  end

end
