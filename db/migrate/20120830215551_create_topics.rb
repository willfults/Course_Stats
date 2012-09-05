class CreateTopics < ActiveRecord::Migration
  def up
	create_table :topics do |t|
		t.string		:name
		t.integer		:last_poster_id
		t.datetime		:last_post_at
		t.datetime		:created_at
		t.datetime		:updated_at
		t.integer		:forum_id
		t.integer		:user_id
	end	
  end

  def down
  end
end
