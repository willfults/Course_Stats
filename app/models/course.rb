
class Course < ActiveRecord::Base
 
  attr_accessible :description, :name, :privacy, :category, :published, :user_id, :tag_list
  
 
  ajaxful_rateable :stars => 5
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
  has_many :forums

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id, type: 'integer'
    indexes :name, analyzer: 'snowball'
    indexes :description, analyzer: 'snowball'
    #indexes :user_name, analyzer: 'snowball'
    indexes :course_rating, type: 'integer'
    indexes :user do
      indexes :name
      indexes :email
    end
    indexes :created_at, type: 'date'
  end
  
  
  
  def self.search(params)
    tire.search do
      query do
        boolean do
          must { string params[:query], default_operator: "AND" } if params[:query].present?
        end
      end
      facet "course_ratings" do
        terms :course_rating, :order => 'term'
      end
      
      facet "authors" do
        terms :user_id, :size => '50'
      end
      
      facet "industries" do
        terms :category
      end
      # raise to_curl
    end
  end
  
  def to_indexed_json
    to_json(methods: [:user_name, :course_rating])
  end
  
  def user_name 
    user.name
  end

  def course_rating 
    rand(1..5)
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

