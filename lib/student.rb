require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(id=nil, name, breed)
  	@id = id
  	@name = name
  	@breed = name
  end

end
