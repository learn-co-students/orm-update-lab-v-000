require_relative "../config/environment.rb"

class Student

  attr_accessor :name
  attr_reader   :grade, :id

  def initialize(name, grade, id=nil)
    @name  = name
    @grade = grade
    @id    = id
  end

  def self.create(name, grade)
    self.new(name, grade).save
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id    INTEGER PRIMARY KEY,
        name  TEXT,
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    sql = "SELECT * from students WHERE name = ? LIMIT 1"
    rows = DB[:conn].execute(sql, name)
    new_from_db(rows[0]) if rows.size > 0
  end

  def self.new_from_db(row)
    self.new(row[1], row[2], row[0])
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, @name, @grade, @id)
  end

  def save
    if @id.nil?
      sql = "INSERT INTO students (name, grade) VALUES (?,?)"
      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
      DB[:conn].execute(sql, @name, @grade, @id)
    end
    self
  end
end
