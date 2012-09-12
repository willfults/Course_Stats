class CreateLinkedinPositions < ActiveRecord::Migration
  def change
    create_table :linkedin_positions do |t|
      t.integer :linkedin_profile_id
      t.string :company_name
      t.string :industry
      t.string :title
      t.text :summary
      t.date :start_date
      t.date :end_date
      t.boolean :is_current

      t.timestamps
    end
  end
end
