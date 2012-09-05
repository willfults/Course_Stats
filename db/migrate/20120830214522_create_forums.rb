class CreateForums < ActiveRecord::Migration
  def up
	create_table :forums do |t|
		t.string		:name
		t.text		:description
		t.datetime		:created_at
		t.datetime		:updated_at
	end	
  end

  def down
  end
end
