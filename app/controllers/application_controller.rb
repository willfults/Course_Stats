class ApplicationController < ActionController::Base
  include MongodbLogger::Base
  protect_from_forgery
  before_filter :logExtraInformation, :getUnreadMessageCount
  
  def logExtraInformation
    if Rails.logger.respond_to?(:add_metadata)
     Rails.logger.add_metadata(:user_id => current_user.id) if current_user.present?
    end
  end
  
  def getUnreadMessageCount
    count = 0
    current_user.mailbox.conversations.each do |conversation|
      if ! conversation.read
        count += 1
      end
    end
    @unread_message_count = count
  end
  
  
  
  
end
