class Quiz < ActiveRecord::Base
  attr_accessible :passing_score, :course_module_id, :quiz_questions_attributes
  
  validates :passing_score, presence: true
  validates_numericality_of :passing_score, :only_integer => true, :message => "is not a number"
  validates :passing_score, :numericality => { :greater_than => 0, :less_than_or_equal_to => 100 }

 
  belongs_to :course_module
  
  has_many :quiz_questions, :dependent => :destroy
  accepts_nested_attributes_for :quiz_questions, :allow_destroy => true
end