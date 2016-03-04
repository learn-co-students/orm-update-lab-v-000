require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    s = self.new(name, grade)
    s.save
    s
  end

  def self.new_from_db(row)
    s = self.new(nil, row[1], row[2])
    s.save
    s
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL
    s = DB[:conn].execute(sql, name).flatten
    self.new(s[0], s[1], s[2])
  end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
