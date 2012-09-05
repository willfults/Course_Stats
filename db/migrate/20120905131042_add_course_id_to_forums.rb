class AddCourseIdToForums < ActiveRecord::Migration
  def change
    add_column :forums, :course_id, :integer
  end
end
