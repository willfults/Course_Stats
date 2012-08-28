class CreateCourseHistory < ActiveRecord::Migration
  def change
    create_table :course_histories do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :status
      
      t.timestamps
    end
  end
end
