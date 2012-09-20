class ApplicationController < ActionController::Base
  include MongodbLogger::Base
  include ApplicationHelper
  include DeviseHelper
  
  protect_from_forgery
  before_filter :logExtraInformation
  
  def logExtraInformation
    if Rails.logger.respond_to?(:add_metadata)
     Rails.logger.add_metadata(:user_id => current_user.id) if current_user.present?
    end
  end
  
  def getUnreadMessageCount
    count = 0
    if user_signed_in?
      current_user.mailbox.conversations.each do |conversation|
        message = Notification.find_by_conversation_id(conversation.id);
        if ! conversation.read && current_user.id != message.sender_id
          count += 1
        end
      end
    end
    @unread_message_count = count
  end
    
  rescue_from CanCan::AccessDenied do |exception|
	flash[:error] = "Access Denied."
	redirect_to root_url
  end


  def after_sign_in_path_for(resource)
 	if ( current_user.role == "creator" )
		manage_courses_path
	elsif ( current_user.role == "user" )
		my_courses_path
	else
		super
	end
  end
  
end
