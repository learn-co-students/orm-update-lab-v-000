require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @id = id;
    @name = name;
    @grade = grade;
  end

  def update
    #update name
    sql = <<-SQL
      UPDATE students SET name = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, @name, @id);


    #update grade
    sql = <<-SQL
      UPDATE students SET grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql, @grade, @id);


  end


  def save
    if self.id != nil
      sql = <<-SQL
        UPDATE students SET name = ? WHERE id = ?
      SQL
      DB[:conn].execute(sql, @name, @id);
    else
      sql = <<-SQL
        INSERT INTO students(name, grade)
        VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, @name, @grade);

      last_id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")
      @id = last_id[0][0];
    end
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL

    DB[:conn].execute(sql);
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql);
  end



  def self.create(name, grade)
    new_student = Student.new(name, grade);
    new_student.save;
    new_student;
  end

  def self.new_from_db(record)
    new_student = Student.new(record[1], record[2], record[0]);
    new_student;
  end

  def self.find_by_name(student_name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    new_student = Student.new_from_db( DB[:conn].execute(sql, student_name)[0] );
    new_student;
  end

end
