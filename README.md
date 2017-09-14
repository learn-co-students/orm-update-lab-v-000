# ORM Update Lab

## Objectives

1. Build an `#update` method that updates an existing record.

## Instructions

In this lab we will be working with a `Student` class. Each student has an `id`, a `name` and a `grade`. Students should be initialized with an id that defaults to `nil`, a name and a grade.

In this lab, our connection to the database is set up for you in the `config/environment.rb` file:

```ruby
DB = {:conn => SQLite3::Database.new("db/students.db")}
```

In your `Student` class, you can access the database connection via: `DB[:conn]`

*You may need to manually create the database before running tests.* You can execute the SQL code you create for your `#create_table` method on a single line wrapped in quotes after the `sqlite3` command and the location of the database.
```
$ mkdir db
$ sqlite3 db/students.db "CREATE TABLE students(...);"
```

You'll be building the following methods:

### The `#initialize` Method

This method takes in three arguments, the id, name and grade. The id should default to `nil`.

### The `#create_table` Method

This class method creates the students table with columns that match the attributes of our individual students: an id (which is the primary key), the name and the grade.

### The `#drop_table` Method

This class method should be responsible for dropping the students table.

### The `#save` Method

This instance method inserts a new row into the database using the attributes of the given object. This method *also* assigns the `id` attribute of the object once the row has been inserted into the database.

### The `#create` Method

This is a class method that uses keyword arguments. The keyword arguments are `name:` and `grade:`. Use the values of these keyword arguments to: 1) instantiate a new `Student` object with `Student.new(name, grade)` and 2) save that new student object via `student.save`.

### The `#new_from_db` Method

This methods an argument of an array. When we call this method we will pass it the array that is the row returned from the database by the execution of a SQL query. We can anticipate that this array will contain three elements in this order: the id, name and grade of a student.

The `#new_from_db` method uses these three array elements to create a new `Student` object with these attributes.

### The `#find_by_name` Method

This method takes in an argument of a name. It queries the database table for a record that has a name of the name passed in as an argument. Then it uses the `#new_from_db` method to instantiate a `Student` object with the database row that the SQL query returns.

### The `#update` Method

This method updates the database row mapped to the given `Student` instance.


<a href='https://learn.co/lessons/orm-update-lab' data-visibility='hidden'>View this lesson on Learn.co</a>
