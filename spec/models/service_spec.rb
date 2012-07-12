require 'spec_helper'

describe Service do

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    @service  = Service.new(user_id: @user.id, provider: "facebook", uid: "123ABC", uname: @user.name, uemail: @user.email)
  end

  it { should respond_to(:user_id) }
  it { should respond_to(:provider) }
  it { should respond_to(:uid) }
  it { should respond_to(:uname) }
  it { should respond_to(:uemail) }

end
# == Schema Information
#
# Table name: services
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  uname      :string(255)
#  uemail     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

