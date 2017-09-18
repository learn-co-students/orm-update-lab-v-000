require_relative "../config/environment.rb"
# Remember, you can access your database connection anywhere in this class with DB[:conn]
class Student
  # Student attributes has a name and a grade
  # Student attributes has an id that defaults to `nil` on initialization
  attr_accessor :name, :grade
  attr_reader  :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  # Student .create creates a student object with name and grade attributes
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end

  # Student .new_from_db creates an instance with corresponding attribute values
  def self.new_from_db(row)
    new_student = self.new(row[0], row[1], row[2])
    new_student
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # Student .find_by_name returns an instance of student that matches the name from the D
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end

  # Student #save saves an instance of the Student class to the database and then sets the given students `id` attribute
  # Student #save updates a record if called on an object that is already persisted
  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  # Student .create_table creates the students table in the database
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

  # Student .drop_table drops the students table from the database
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  # Student #update updates the record associated with a given instance
  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
