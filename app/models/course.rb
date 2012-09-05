class Course < ActiveRecord::Base
  attr_accessible :description, :name, :privacy, :category, :published, :user_id, :tag_list
  
 
  
  # acts as taggable on roids
  acts_as_taggable
  
  
  validates :name, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :privacy, presence: true
  validates :user_id, presence: true
  validate :publish
  
  def publish
    if published == true && self.course_modules.size == 0
      errors[:base] << "Unable to publish courses that have no modules."
      self.published = false

    end
  end

  
  
  belongs_to :user
  has_many :course_modules, :order => "position"

  def self.search(query)
    find_by_sql [ "SELECT * FROM courses WHERE MATCH (name, description) AGAINST ('"+ query +"') "]
  end

end
