require_relative "../config/environment.rb"

class Student
  attr_accessor :name ,:grade, :id

  def initialize(name=nil,grade=nil,id=nil)
    @name=name
    @grade=grade
    @id=id
  end
  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
  end
  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end
  def save
    if self.id
      self.update
    else
      DB[:conn].execute("INSERT INTO students (name,grade) VALUES (?,?)",self.name,self.grade)
    end
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  def update
    DB[:conn].execute("UPDATE students SET name= ?, grade= ? WHERE id= ?", self.name,self.grade,self.id)
  end
  def self.create(name,grade)
    new_student= self.new(name,grade)
    new_student.save
    new_student
  end
    def self.new_from_db(row)
      new_song=self.new
      new_song.id=row[0]
      new_song.name=row[1]
      new_song.grade=row[2]
      new_song
      # create a new Student object given a row from the database
    end
    def self.find_by_name(name)
      DB[:conn].execute("SELECT * FROM students WHERE name= ? LIMIT 1", name).map do |row|
        self.new_from_db(row)
      end.first
      # find the student in the database given a name
      # return a new instance of the Student class
    end


  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
