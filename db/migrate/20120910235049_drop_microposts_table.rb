class DropMicropostsTable < ActiveRecord::Migration
  def up
	drop_table :microposts
  end

  def down
  end
end
