class ModifyLinkedinProfilesSummary < ActiveRecord::Migration
  def up
    remove_column :linkedin_profiles, :summary
    add_column :linkedin_profiles, :summary, :text
  end

  def down
    remove_column :linkedin_profiles, :summary
    add_column :linkedin_profiles, :summary, :string
  end
end
