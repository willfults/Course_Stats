class LinkedinProfile < ActiveRecord::Base
  attr_accessible :headline, :name, :summary, :public_profile_url, :user_id
  
  belongs_to :user
  has_many :linkedin_positions
  has_many :linkedin_educations
end
# == Schema Information
#
# Table name: linkedin_profiles
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  headline   :string(255)
#  summary    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

