require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name


  end


  def self.columns_names


  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end  
  end
  
end