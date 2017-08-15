require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name=nil,grade=nil)
    @name=name
    @grade=grade
    @id=nil
  end
  def self.new_from_db(row)
     obj= self.new
     obj.id=row[0]
     obj.name=row[1]
     obj.grade=row[2]
     obj
    # create a new Student object given a row from the database
  end

  def self.all
    sql= <<-SQL
       SELECT * from students
       SQL
       DB[:conn].execute(sql).map do |e|
         self.new_from_db(e)
       end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end
  def self.count_all_students_in_grade_9
   list=[]
   sql= <<-SQL
      SELECT * FROM students WHERE grade=?
      SQL
      DB[:conn].execute(sql,9).each do |e|
        obj=self.new_from_db(e)
        list<<obj
      end
      list
  end
  def self.create(name,grade)
    student = Student.new(name,grade)
    student.save
    student
  end

  def save
    if @id!=nil
      self.update
    else
    save_sql=<<-SQL
    INSERT INTO students(name,grade) VALUES (?,?)
    SQL
    DB[:conn].execute(save_sql,@name,@grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
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


def update
   sql=<<-SQL
    UPDATE students SET name=?,grade=? WHERE id=?

  SQL

  DB[:conn].execute(sql,@name,@grade,@id)
end

def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.find_by_name(name)
    sql= <<-SQL
       SELECT * from students where name = ?
       SQL
       DB[:conn].execute(sql,name).map do |e|
         self.new_from_db(e)

       end.first


    # find the student in the database given a name
    # return a new instance of the Student class
  end

end
