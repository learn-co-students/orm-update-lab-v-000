require_relative '../config/environment.rb'
require 'pry'
require 'IRB'

IRB.start

def reload
  require_relative '../config/environment.rb'
end
