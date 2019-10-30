require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
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

  def self.drop_table
    sql = "DROP TABLE students"

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      insert = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(insert, self.name, self.grade)

      id_sql = "SELECT last_insert_rowid() FROM students"
      @id = DB[:conn].execute(id_sql)[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    grade = row[2]

    student = self.new(name, grade, id)
  end

  def self.find_by_name(name)

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      # binding.pry
      self.new_from_db(row)
    end.first

  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

end
