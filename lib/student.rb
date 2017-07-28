require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade, :id

  def initialize(id = nil, name, grade)
    self.name = name
    self.grade = grade
    self.id = id
  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.create(name, grade)
    Student.new(name, grade).tap{|student| student.save}
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    # save record to database
    save_sql = <<-SQL
      INSERT INTO students(name, grade) VALUES (?, ?);
    SQL

    DB[:conn].execute(save_sql, self.name, self.grade)

    # update record's id

    load_sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL

    load_data = DB[:conn].execute(load_sql, self.name)[0]
    self.id = load_data[0]
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?;
    SQL

    self.new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def update

    update_sql = <<-SQL
      UPDATE students SET name = (?), grade = (?) WHERE id = ?;
    SQL

    DB[:conn].execute(update_sql, self.name, self.grade, self.id)
  end
end
