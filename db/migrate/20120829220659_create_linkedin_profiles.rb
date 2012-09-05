class CreateLinkedinProfiles < ActiveRecord::Migration
  def change
    create_table :linkedin_profiles do |t|
      t.string :name
      t.string :headline
      t.string :summary
      t.integer :user_id

      t.timestamps
    end
  end
end
