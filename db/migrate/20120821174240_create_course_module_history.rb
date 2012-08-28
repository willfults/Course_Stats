class CreateCourseModuleHistory < ActiveRecord::Migration
  def change
    create_table :course_module_histories do |t|
      t.integer :user_id
      t.integer :course_history_id
      t.integer :course_module_id
      t.string :status
      
      t.timestamps
    end
  end
end
