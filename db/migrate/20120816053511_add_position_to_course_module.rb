class AddPositionToCourseModule < ActiveRecord::Migration
  def change
    add_column :course_modules, :position, :integer, :default => 0
  end
end
