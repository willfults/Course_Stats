#
# this class currently contains statistical data for videos namely plays and completions
#

class Statistic
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia

  field :class_id, type: Integer # index this field, used for queries
  field :course_id, type: Integer
  field :user_id, type: Integer
  field :status, type: String # currently this is either play or complete
  
  validates_presence_of :course_id
  validates_presence_of :class_id
  validates_presence_of :user_id
  
  scope :ordered, order_by(:created_at => :asc)

end
