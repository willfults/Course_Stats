class Course < ActiveRecord::Base
  attr_accessible :description, :name, :privacy, :category, :published, :user_id, :tag_list
  
 
  
  # acts as taggable on roids
  acts_as_taggable
  
  
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :privacy, presence: true
  validates :user_id, presence: true
  
  belongs_to :user
  has_many :course_modules, :order => "position"

  def self.search(query)
    find_by_sql [ "SELECT * FROM courses WHERE MATCH (name, description) AGAINST ('"+ query +"') "]
  end

end
# == Schema Information
#
# Table name: courses
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  category    :string(255)
#  privacy     :string(255)
#  published   :boolean
#

