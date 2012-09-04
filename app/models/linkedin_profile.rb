class LinkedinProfile < ActiveRecord::Base
  attr_accessible :headline, :name, :summary, :user_id
  
  belongs_to :user
end
