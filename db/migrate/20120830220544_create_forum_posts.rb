class CreateForumPosts < ActiveRecord::Migration
  def up
	create_table :forumposts do |t|
		t.text		:content
		t.datetime		:created_at
		t.datetime		:updated_at
		t.integer		:topic_id
		t.integer		:user_id
	end	
  end

  def down
  end
end
