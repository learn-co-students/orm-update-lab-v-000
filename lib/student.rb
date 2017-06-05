require_relative "../config/environment.rb"

class Student


#------------------------------------------------------------
#macro/meta
attr_accessor :id, :name, :grade



#------------------------------------------------------------
#instance
def initialize (name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
end


def save

  #if it has already been saved
  if self.id
      self.update
  
  #if it hasn't already been saved
  else

      sql = <<-SQL
            INSERT INTO students (name, grade) 
            VALUES (?, ?)
            SQL
      DB[:conn].execute(sql, self.name, self.grade)
      
      
      #get last row of only this table
      self.id = DB[:conn].execute("SELECT last_insert_rowid() from students")[0][0]
      
      end

#eom
end


def self.create (name, grade, id = nil)
self.new(name,grade,id).save
end



def update
sql = <<-SQL
      UPDATE students 
      set name = ?, grade = ? 
      where id = ?
      SQL
DB[:conn].execute(sql, self.name, self.grade, self.id)
end







#------------------------------------------------------------
#class methods
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
    sql = "DROP TABLE IF EXISTS students;"
    DB[:conn].execute(sql)
end

def self.new_from_db(row)
Student.new(row[1],row[2],row[0])
end


def self.find_by_name(name)
sql = <<-SQL
      SELECT * from students
      WHERE name = ?
      SQL

self.new_from_db(DB[:conn].execute(sql,name)[0])

end






#eoc---------------------------------------------------------
end
