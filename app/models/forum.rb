class Forum < ActiveRecord::Base
	
	attr_accessible :description, :name, :course_id
 
	has_many :topics, :dependent => :destroy
	
	validates :name, :presence => true, :uniqueness => true, 
				:length => { :maximum => 255, :too_long => "%{count} characters is the max allowed" }
	validates :description, :presence => true

	def most_recent_topic
		topic = Topic.first(:order => 'created_at DESC', :conditions => ['forum_id = ?', self.id])
		return topic
	end
end
