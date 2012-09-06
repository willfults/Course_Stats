class CreateQuizAnswers < ActiveRecord::Migration
  def change
    create_table :quiz_answers do |t|
      t.string :answer
      t.boolean :correct_answer
      t.integer :quiz_question_id

      t.timestamps
    end
  end
end
