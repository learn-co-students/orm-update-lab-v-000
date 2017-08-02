require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end


  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

  def save

    if @id
      update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?,?)
      SQL

      DB[:conn].execute(sql, @name, @grade)

      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = <<-SQL
      UPDATE students
      SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def self.create(name, grade)
    x = self.new(name, grade)
    x.save
    x
  end

  def self.new_from_db(row)
    x = self.new(row[1],row[2])
    x.id = row[0]
    x
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map {|row|
      self.new_from_db(row)
    }.first

  end
end
