class CreateCourseForums < ActiveRecord::Migration

  def up
	create_table :courseforums do |t|
		t.integer		:course_id
		t.integer		:forum_id
		t.datetime		:created_at
		t.datetime		:updated_at
	end	
  end

  def down
  end
end
