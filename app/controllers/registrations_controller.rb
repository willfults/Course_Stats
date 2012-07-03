class RegistrationsController < Devise::RegistrationsController

  def after_update_path_for(resource)
    if resource_params[:image].present?
      crop_user_path(resource)
    else
      signed_in_root_path(resource)
    end
  end

end