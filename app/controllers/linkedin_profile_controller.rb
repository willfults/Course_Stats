class LinkedinProfileController < ApplicationController
 
  before_filter :authenticate_user!
  
  def edit
    @linkedin_profile = get_linkedin_profile
  end
  
  def update
      linkedin_profile = LinkedinProfile.find_by_user_id(current_user.id)
      
      if !linkedin_profile
        linkedin_profile = LinkedinProfile.new
      end
      
      if linkedin_profile.update_attributes(params[:linkedin_profile])
        flash[:success] = "Linked In Profile saved!"
        redirect_to current_user
      else
         render :action => 'edit'
      end
  end
  
  private
  
    def get_linkedin_profile
      linkedin_profile = current_user.linkedin_profile ||= LinkedinProfile.new
      if session[:linkedin_credentials]
        token = session[:linkedin_credentials]['token']
        secret = session[:linkedin_credentials]['secret']
        client = LinkedIn::Client.new($LINKEDIN_APP_KEY, $LINKEDIN_APP_SECRET)
        client.authorize_from_access(token, secret)
        linkedin = client.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions, :public_profile_url])
        
        # use saved values if they exist, linkedin values if not
        if !linkedin_profile.name
          linkedin_profile.name = linkedin[:first_name] + " " + linkedin[:last_name]
        end
        if !linkedin_profile.headline
          linkedin_profile.headline = linkedin[:headline]
        end
        if !linkedin_profile.summary
          linkedin_profile.summary = linkedin[:summary]
        end
        if !linkedin_profile.public_profile_url
          linkedin_profile.public_profile_url = linkedin[:public_profile_url]
        end
        linkedin_profile.user_id = current_user.id
      end
      linkedin_profile
    end
    
end
