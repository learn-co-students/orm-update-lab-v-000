require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id


  def self.create_table
    sql = <<-SQL
     CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER
  )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
      sql = "DROP TABLE students"
      DB[:conn].execute(sql)
  end

  def self.create(id = nil , name, grade)
    obj = self.new(id, name, grade)
    obj.save
    obj
  end

  def self.new_from_db(row)
    id    =  row[0]
    name  =  row[1]
    grade =  row[2]
    self.create(id, name, grade)
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM STUDENTS WHERE name = ?
    SQL
    self.new_from_db( DB[:conn].execute(sql,name)[0] )

  end

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade =  grade
  end

  def save
    if self.id
      sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id=?
      SQL
      DB[:conn].execute(sql,self.name, self.grade, self.id)
    else
      sql = <<-SQL
      INSERT INTO students(name, grade)VALUES(?,?)
      SQL
      DB[:conn].execute(sql,self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() students")[0][0]
    end

    def update
        self.save
    end

  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
