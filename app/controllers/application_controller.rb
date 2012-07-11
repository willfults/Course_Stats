class ApplicationController < ActionController::Base
  include MongodbLogger::Base
  protect_from_forgery
  before_filter :logExtraInformation
  
  def logExtraInformation
    if Rails.logger.respond_to?(:add_metadata)
     Rails.logger.add_metadata(:user_id => current_user.id) if current_user.present?
    end
  end
end
