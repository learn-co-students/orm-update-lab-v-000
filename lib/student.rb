require_relative "../config/environment.rb"

class Student
attr_accessor :id, :name, :grade

@@all =[]

  def initialize(id=nil, name, grade)
    @name=name
    @grade=grade
    @id=id
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students
        (id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
        DROP TABLE students
      SQL
      DB[:conn].execute(sql)
    end

    def save
      current_database_number=DB[:conn].execute("SELECT * FROM students").length
      if self.id != nil
        if self.id < current_database_number || self.id == current_database_number
          DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?",self.name, self.grade, self.id)
        end
      else
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?,?)",self.name, self.grade)
      @id=DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end

    def self.create(name, grade)
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?,?)",name, grade)
      new_student=self.new(DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0],name,grade)
      @@all << new_student
      new_student
    end

    def self.new_from_db(row)
      id = row[0]
      name =row[1]
      grade =row[2]
      Student.new(id, name, grade)
    end

    def self.find_by_name(name)
      self.new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0])
    end

    def update
      self.save
    end

    def self.all
      @@all
    end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
