require 'carrierwave/mongoid'

class Avatar
  include Mongoid::Document
  mount_uploader :image, ImageUploader
end