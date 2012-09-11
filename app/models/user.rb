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
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :confirmed_at, :avatar, :twitter_username, :display_name
  acts_as_messageable # for mailbox
  ajaxful_rater # for star rating
  
  attr_readonly :display_name
  validates :display_name, :presence => true

  has_one :linkedin_profile
  has_many :courses
  has_many :course_histories
  after_initialize :handle_after_initialize
  
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
 

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def handle_after_initialize
    self.display_name ||= self.slug # if the display_name is not set, use the slug as a default value
  end
  
  private

    def isCropped?
     self.crop_x.present?
    end
    
    def username
      self.name.downcase.strip if self.name.present?
    end
end
