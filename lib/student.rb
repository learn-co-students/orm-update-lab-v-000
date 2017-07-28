require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create(name, grade)
    new_song = self.new(name, grade)
    new_song.save
    new_song
  end

  def self.new_from_db(row)
    song = self.new(row[0], row[1], row[2])
    song
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
    sql = <<-SQL
      DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).flatten
    self.new_from_db(row)
  end

  def update
      sql = <<-SQL
        UPDATE students SET name = ?, grade = ?
        WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      DB[:conn].execute("UPDATE students SET name = ?, grade = ?", self.name, self.grade)
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
    end
  end

end
