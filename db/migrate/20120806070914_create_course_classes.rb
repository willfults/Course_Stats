class CreateCourseClasses < ActiveRecord::Migration
  def change
    create_table :course_classes do |t|
      t.string :name
      t.text :summary
      t.string :class_type
      t.string :file
      t.integer :course_id

      t.timestamps
    end
  end
end
