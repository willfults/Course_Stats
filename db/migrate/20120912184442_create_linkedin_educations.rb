class CreateLinkedinEducations < ActiveRecord::Migration
  def change
    create_table :linkedin_educations do |t|
      t.integer :linkedin_profile_id
      t.string :school_name
      t.date :start_date
      t.date :end_date
      t.string :degree
      t.string :field_of_study

      t.timestamps
    end
  end
end
