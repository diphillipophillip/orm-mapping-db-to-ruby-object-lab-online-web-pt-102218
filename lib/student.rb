require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = "SELECT * FROM students"
    DB[:conn].execute(sql).map do |i| 
      self.new_from_db(i)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    DB[:conn].execute(sql, name).map do |i| 
      self.new_from_db(i)
    end.first
  end
  
  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = '9'"
    this = DB[:conn].execute(sql)
  end
  
  def self.students_below_12th_grade 
    sql = "SELECT * FROM students WHERE grade < '12'"
    this = DB[:conn].execute(sql).flatten
    this
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
