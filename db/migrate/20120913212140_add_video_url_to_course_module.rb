class AddVideoUrlToCourseModule < ActiveRecord::Migration
  def change
    add_column :course_modules, :video_url, :string
  end
end
