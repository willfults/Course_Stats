# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)     default(""), not null
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean         default(FALSE)
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  image                  :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  slug                   :string(255)
#  avatar                 :string(255)
#  twitter_username       :string(255)
#

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :confirmed_at, :avatar, :twitter_username
  acts_as_messageable # for mailbox
  ajaxful_rater # for star rating
  
  has_one :linkedin_profile
  has_many :courses
  has_many :course_histories
  has_many :bookmarks
  
  validates :username, presence: true
  validates_length_of :username, :minimum =>6
  
  
  
  accepts_nested_attributes_for :linkedin_profile
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :services, :dependent => :destroy
  mount_uploader :image, ImageUploader

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :topics, :dependent => :destroy
  has_many :forumposts, :dependent => :destroy
 
  include Tire::Model::Search
  include Tire::Model::Callbacks
 
  mapping do
    indexes :id, type: 'integer'
    indexes :name, analyzer: 'snowball'
  end
 
  # this is a fix for tire:import's feature being broken on models that are linked to Devise
  def password_digest(*args)
    my_password = ''
    if args.length == 1
      password = args[0]
      my_password = ::BCrypt::Password.create("#{password}#{self.class.pepper}", :cost => self.class.stretches).to_s
    end
    my_password
  end
 
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  
  private

    def isCropped?
     self.crop_x.present?
    end
    
    def username
      self.name.downcase.strip if self.name.present?
    end
end
