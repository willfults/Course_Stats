
class Course < ActiveRecord::Base
 
  attr_accessible :description, :name, :privacy, :category, :published, :user_id, :tag_list, :rating_average
  
 
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
  accepts_nested_attributes_for :course_modules, :allow_destroy => true
  attr_accessible :course_modules_attributes

  has_many :forums

  include Tire::Model::Search
  include Tire::Model::Callbacks

  mapping do
    indexes :id, type: 'integer'
    indexes :name, analyzer: 'snowball'
    indexes :description, analyzer: 'snowball'
    indexes :category
    indexes :course_rating, type: 'integer'
    indexes :user_id
    indexes :user do
      indexes :name
      indexes :email
    end
    indexes :course_modules do
      indexes :name
      indexes :summary
    end
    indexes :created_at, type: 'date'
  end
  
  def self.facets(params) 
    Tire.search ['courses'] do
      query do
        boolean do
          must { string params[:query], default_operator: "AND" } if params[:query].present?
          must { string "*", default_operator: "AND" } if !params[:query].present?
          must { term :course_rating, params[:course_rating] } if params[:course_rating].present?
          must { term :user_id, params[:author] } if params[:author].present?
          must { term :category, params[:industry] } if params[:industry].present?
        end
      end
      
      
      facet "authors" do
        terms :user_id, :size => '50', :global => true
      end
      
      facet "industries" do
        terms :category, :global => true
      end
      
      facet "course_ratings" do
        terms :course_rating, :global => true, :order => :term
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
    rating_average.to_int
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

