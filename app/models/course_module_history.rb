class CourseModuleHistory < ActiveRecord::Base
  attr_accessible :course_history_id, :course_module_id, :status, :created_at
  
 
  validates :course_history_id, presence: true
  
  has_one :user

  belongs_to :course_history

end
