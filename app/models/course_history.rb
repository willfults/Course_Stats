class CourseHistory < ActiveRecord::Base
  attr_accessible :user_id, :course_id, :status, :created_at
  
 
  validates :user_id, presence: true
  validates :course_id, presence: true
  
  belongs_to :course
  has_one :user
  has_many :course_module_histories

end
# == Schema Information
#
# Table name: course_histories
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  course_id  :integer
#  status     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

