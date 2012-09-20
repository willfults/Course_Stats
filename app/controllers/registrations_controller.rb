class RegistrationsController < Devise::RegistrationsController
	include ApplicationHelper

  def after_update_path_for(resource)
    if resource_params[:image].present?
      crop_user_path(resource)
    else
      signed_in_root_path(resource)
    end
  end

  def new
    ayah_view_init
    super
  end
  
  def create
    session_secret = params['session_secret'] # in this case, using Rails 
    ayah = ayah_init
    ayah_passed = ayah.score_result(session_secret, request.remote_ip) 

    build_resource
    
    begin
      if ! ayah_passed || ! resource.valid?
        resource.errors.add(:captcha, "failed validation") if ! ayah_passed
        ayah_view_init
        render :new  
      else
        super
      end
    rescue Exception  # exception handling needed in case of duplicate emails
      ayah_view_init
      render :new  
    end
  end
   
end