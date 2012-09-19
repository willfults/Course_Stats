class LinkedinPosition < ActiveRecord::Base
  attr_accessible :company_name, :end_date, :industry, :is_current, :linkedin_profile_id, :start_date, :summary, :title
  belongs_to :linkedin_profile

end
