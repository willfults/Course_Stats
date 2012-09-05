class CourseModuleHistory < ActiveRecord::Base
  attr_accessible :course_history_id, :course_module_id, :status, :created_at
  
 
  validates :course_history_id, presence: true
  
  has_one :user

  belongs_to :course_history

end
# == Schema Information
#
# Table name: course_module_histories
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  course_history_id :integer
#  course_module_id  :integer
#  status            :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

