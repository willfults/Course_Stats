class QuizAnswer < ActiveRecord::Base
  attr_accessible :answer, :correct_answer, :quiz_question_id
  
  validates :answer, presence: true
  
  
  
  
  
  belongs_to :quiz_question
end