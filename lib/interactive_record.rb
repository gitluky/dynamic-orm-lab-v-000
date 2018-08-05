require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end


  def self.column_names
    sql = <<-SQL
      SELECT PRAGMA table_info (#{self.table_name})
    SQL

    table_columns = []

    DB[:conn].execute(sql).each do |column|
      table_columns << column["name"]
    end

  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end

end
