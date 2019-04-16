require_relative "../config/environment.rb"

class Student
  attr_accessor :name,:grade,:id
  def initialize name, grade
    @name=name;@grade=grade;@id=nil
  end
  def save
    if @id==nil
      DB[:conn].execute("INSERT INTO students (name,grade) VALUES(?,?)",@name,@grade)
      @id=DB[:conn].execute("SELECT id FROM students WHERE name IS ?",@name)[0][0]
    else
      DB[:conn].execute("UPDATE students SET name=? WHERE id=?",@name,@id)
      DB[:conn].execute("UPDATE students SET grade=? WHERE id=?",@grade,@id)
    end
  end
  def self.create name,grade
     self.new(name,grade).save
  end
  def self.new_from_db row
     r=self.new(row[1],row[2]);r.id=row[0];r
  end
  def self.find_by_name name
     new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name IS ?",name)[0])
  end
  def update
     save
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
      DB[:conn].execute(sql)
   end
  def self.drop_table
      DB[:conn].execute("DROP TABLE IF EXISTS students")
  end



end
