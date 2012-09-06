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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
