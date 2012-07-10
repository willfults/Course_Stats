class RemoveLinkedinIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :linkedin_id
  end

  def down
    add_column :users, :linkedin_id, :string
  end
end
