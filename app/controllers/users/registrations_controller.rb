class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  def create
    build_resource(sign_up_params)
 
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        return render :json => {:success => true}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render :json => {:success => true}
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.json { render json: resource.errors, status: :unprocessable_entity }
        format.js   { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) {|u|u.permit( :name, :phone, :email, :password, :password_confirmation)}
  end
  
  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
  end
end