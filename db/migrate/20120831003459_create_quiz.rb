class CreateQuiz < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :passing_score
      t.integer :course_module_id

      t.timestamps
    end
  end
end
