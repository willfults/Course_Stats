class Topic < ActiveRecord::Base

	attr_accessible :name, :last_poster_id, :last_post_at, :forum_id, :user_id
    
	belongs_to :forum
	belongs_to :user

	has_many :forumposts, :dependent => :destroy

	validates :name, :presence => true, :uniqueness => true, 
			:length => { :maximum => 255, :too_long => "%{count} characters is the max allowed" }


end
