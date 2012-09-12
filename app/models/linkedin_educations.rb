class LinkedinEducations < ActiveRecord::Base
  attr_accessible :degree, :end_date, :field_of_study, :linkedin_profile_id, :school_name, :start_date

  belongs_to :linkedin_profile
end
