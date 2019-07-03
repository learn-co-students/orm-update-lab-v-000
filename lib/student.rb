require 'pry'
require_relative "../config/environment.rb"

class Student
    attr_accessor :name, :grade
    attr_reader :id

    def initialize(id = nil, name, grade)
        @id, @name, @grade = id, name, grade
    end

    def self.create_table
        sql = "CREATE TABLE IF NOT EXISTS students (id integer primary key, name text, grade text)"
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS students"
        DB[:conn].execute(sql)
    end

    def save
        if self.id
            self.update
        else
            sql = "INSERT INTO students (name, grade) values (?, ?)"
            DB[:conn].execute(sql, self.name, self.grade)
            @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
        end
    end

    def self.create(name, grade)
        student = self.new(name, grade)
        student.save
        student
    end

    def self.new_from_db(row)
        student = self.new(row[0],row[1], row[2])
        student.save
        student
    end

    def self.find_by_name(name)
        # binding.pry #[[id, name, grade]]
        sql = "select * from students where name = ?"
        DB[:conn].execute(sql, name).map { |row|  self.new_from_db(row)}.first
    end

    def update
        sql = "Update students set name = ?, grade = ? where id = ?"
        DB[:conn].execute(sql, self.name, self.grade, self.id)
    end
end
