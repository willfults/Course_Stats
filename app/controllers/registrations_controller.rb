class RegistrationsController < Devise::RegistrationsController

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
    
    resource.errors.add(:captcha, "failed validation") if ! ayah_passed
    if ! resource.save || ! ayah_passed
      ayah_view_init
      render :new  
    else
      super
    end
  end
  
  private 
    def ayah_init
      ayah = AYAH::Integration.new("d5fbcc5d5d32f645158e72fc00b55eea205b13b4", "3969dc9a22c5378abdfc1d576b8757a8638b16d7")
    end

    def ayah_view_init
      ayah = ayah_init
      @captcha_html = ayah.get_publisher_html
    end
end