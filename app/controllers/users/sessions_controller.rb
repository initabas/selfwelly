class Users::SessionsController < Devise::SessionsController
  
  # GET /resource/sign_in
#   def new
#     self.resource = resource_class.new(sign_in_params)
#     clean_up_passwords(resource)
#     respond_with(resource, serialize_options(resource))
#   end
  
#   # POST /resource/sign_in
#   def create
#     self.resource = warden.authenticate!(auth_options)
#     set_flash_message(:notice, :signed_in) if is_navigational_format?
#     sign_in(resource_name, resource)

#     respond_to do |format|
#       format.json { render json: resource.errors, status: :unprocessable_entity }
#       format.js   { render json: resource.errors, status: :unprocessable_entity }
#     end
#   end
#   
#   
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in_and_redirect(resource_name, resource)
  end
 
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    return render :json => {:success => true}
  end
 
#   def destroy
#     respond_to do |format|
#     	format.html do
#         redirect_to '/'
#       end
#   	end
#   end
  
  def failure
    return render :json => {:success => false, :errors => [t(:login_failed)]}
  end
end