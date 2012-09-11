class DropCourseForumsTable < ActiveRecord::Migration
  def up
	drop_table :courseforums
  end

  def down
  end
end
