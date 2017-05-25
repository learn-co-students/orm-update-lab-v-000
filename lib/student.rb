require_relative "../config/environment.rb"

class Student
  attr_reader :id
  attr_accessor :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    if @id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade) # insert it into database
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] # set the ID to the last ID added to the database
    end
    return self # return the modified object not the ID
  end
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def self.create(name, grade)
    student = self.new(name, grade).save
  end
  def self.new_from_db(row)
    student = self.new(row[1], row[2], row[0])
  end
  def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).map{ |row| self.new_from_db(row)}.first
  end
  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY,name TEXT,grade TEXT)")
  end
  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

end
