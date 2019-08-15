require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def update
    update_sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(update_sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
      save_sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
      SQL
      DB[:conn].execute(save_sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.find_by_name(name)
    name_sql = "SELECT * FROM students WHERE name = ?;"
    found = DB[:conn].execute(name_sql, name)[0]
    self.new(found[0], found[1], found[2])
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.create_table
    table_sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    SQL
    DB[:conn].execute(table_sql)
  end

  def self.drop_table
    drop_sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(drop_sql)
  end

  def self.new_from_db(array)
    student = self.new(array[0], array[1], array[2])
  end

end
