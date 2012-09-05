class Courseforum < ActiveRecord::Base
	
	attr_accessible :course_id, :forum_id
	
	has_one :forum

	belongs_to :course, class_name: "Course"
	belongs_to :forum, class_name: "Forum"
	 	     
	validates :course_id, :presence => true 
	validates :forum_id, :presence => true
	
end
