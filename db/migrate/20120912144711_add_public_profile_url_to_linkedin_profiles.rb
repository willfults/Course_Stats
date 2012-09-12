class AddPublicProfileUrlToLinkedinProfiles < ActiveRecord::Migration
  def change
    add_column :linkedin_profiles, :public_profile_url, :string
  end
end
