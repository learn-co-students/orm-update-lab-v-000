require_relative "../config/environment.rb"

require 'pry'

class Student

  attr_accessor :name, :grade
  attr_reader :id

  @@all = Array.new

  def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMAY KEY,
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

    def save
      if self.id
        sql = <<-SQL
        UPDATE students SET name = ?, grade = ? WHERE id = ?
        SQL
        DB[:conn].execute(sql, self.name, self.grade, self.id)

      else
        sql = <<-SQL
        INSERT iNTO students (name, grade)
        VALUES (?, ?)
        SQL
        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
      end
    end

    def self.create(name, grade)
      student = Student.new(name, grade)
      student.save
      student
    end

    def self.new_from_db(row)
      student = self.new(row[1], row[2], row[0])
    end

    def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM students WHERE name = ?
        SQL
      id_name_grade = DB[:conn].execute(sql, name).join(",").split(",")
      our_instance = @@all.detect{|student| student.id == id_name_grade[0].to_i && student.name == id_name_grade[1] && student.grade == id_name_grade[2]}
    end

    def update
      sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
      SQL
      DB[:conn].execute(sql, self.name, self.grade, self.id)
    end





end
