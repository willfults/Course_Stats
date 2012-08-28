class RenameCourseClassesToCourseModules < ActiveRecord::Migration
  def self.up
    rename_table :course_classes, :course_modules
  end

 def self.down
    rename_table :course_modules, :course_classes
 end
end
