class QuizQuestion < ActiveRecord::Base
  attr_accessible :question, :quiz_id, :quiz_answers_attributes
  
  validates :question, presence: true
  validate :must_have_correct_answer
   
  # Check to make sure a correct answer exists.
  def must_have_correct_answer
    self.quiz_answers.each do |answer|
      puts answer.correct_answer
      if answer.correct_answer
        return
      end
    end
    self.errors.add(:question, "Must have a correct answer.")
  end

  
  def reject_answers(attributed)
    returnVal = false
    # Only remove answers if the question is new. Dont remove answers when editing.
    if self.new_record?
      no_answers = true
      
      # Check to see if all answers are empty. If they are we dont want to delete them all.
      self.quiz_answers.each do |answer|
        if !answer.answer.empty?
          no_answers = false
        end
      end
      
      # Delete the current answer if following is true.
      returnVal = !no_answers && (attributed['answer'].blank? && attributed['correct_answer'] != 1)
    end
    returnVal
  end
    
  belongs_to :quiz
  
  has_many :quiz_answers
  accepts_nested_attributes_for :quiz_answers, :reject_if => :reject_answers, :allow_destroy => true
end