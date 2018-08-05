require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end


  def self.column_names

    sql = <<-SQL
      PRAGMA table_info("#{self.table_name}")
    SQL

    table_columns = []

    DB[:conn].execute(sql).each do |column|
      table_columns << column["name"]
    end
    table_columns
  end

  def initialize(options={})
    options.each do |property, value|
      self.send("#{property}=", value)
    end
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|column| column == "id"}.join(", ")
  end

  def values_for_insert
    self.class.column_names.collect do |column_name|
      "#{self.send(column_name)}" unless self.send("#{column_name}").nil?
    end.reject {|value| value.nil?}.join(", ")
  end

  def save
    sql = <<-SQL
      INSERT INTO #{self.class.table_name}("#{col_names_for_insert}")
      VALUES ("#{values_for_insert}")
    SQL

    DB[:conn].execute(sql)

  end


end
