class RemoveDispayNameFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :display_name
  end

  def down
  end
end
