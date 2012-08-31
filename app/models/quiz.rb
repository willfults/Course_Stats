class Quiz < ActiveRecord::Base
  attr_accessible :passing_score, :course_module_id, :quiz_questions_attributes
  
  validates :passing_score, presence: true
  validates_numericality_of :passing_score, :only_integer => true, :message => "is not a number"
  validate :passing_score_less_than_total_questions
 
  def passing_score_less_than_total_questions 
    if passing_score && self.quiz_questions.size < passing_score
      self.errors.add(:passing_score, "Passing score must be less than or equal to the number of questions.")
    end
  end
 
  belongs_to :course_module
  
  has_many :quiz_questions, :dependent => :destroy
  accepts_nested_attributes_for :quiz_questions, :allow_destroy => true
end