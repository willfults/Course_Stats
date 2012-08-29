class LinkedinProfile < ActiveRecord::Base
  attr_accessible :headline, :name, :summary, :user_id
end
