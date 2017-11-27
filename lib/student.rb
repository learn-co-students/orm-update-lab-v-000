require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name,grade,id = nil)
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
      );
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE students')
  end

  def save
    if @id != nil
      self.update
    else
      sql = 'INSERT INTO students (name,grade) VALUES (?,?)'
      DB[:conn].execute(sql,@name,@grade)
      @id = DB[:conn].execute('SELECT last_insert_rowid() FROM students')[0][0]
    end
  end

  def self.create(name,grade)
    new_student = self.new(name,grade)
    new_student.save
    new_student
  end

  def self.new_from_db(row)
    new_student = self.new(row[1],row[2],row[0])
    new_student
  end

  def self.find_by_name(name)
    sql = 'SELECT * FROM students WHERE name = ?'
    row = DB[:conn].execute(sql,name)[0]
    found_student = self.new(row[1], row[2], row[0])
    found_student
  end

  def update
    sql = 'UPDATE students SET name = ?, grade = ? WHERE id = ?'
    DB[:conn].execute(sql,@name,@grade,@id)
  end

end
