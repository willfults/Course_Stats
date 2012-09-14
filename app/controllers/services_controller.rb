class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
  $LINKEDIN_HASH = nil
  
  def index
    # get all authentication services assigned to the current user
    @services = current_user.services.all
  end
  
  def destroy
    # remove an authentication service linked to the current user
    @service = current_user.services.find(params[:id])
    @service.destroy

    redirect_to services_path
  end
  
  def new
    
  end

  def create
    # get the service parameter from the Rails router
    params[:service] ? service_route = params[:service] : service_route = 'no service (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differ for every service
      if service_route == 'facebook'
        omniauth['info']['email'] ? email = omniauth['info']['email'] : email = ''
        omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
        omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
        omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
      elsif service_route == 'linkedin'
        email = '' # linkedin does not provide the email address
        omniauth['info']['name'] ? name =  omniauth['info']['name'] : name = ''
        omniauth['uid'] ?  uid =  omniauth['uid'] : uid = ''
        omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
        $LINKEDIN_HASH = omniauth
      else
        # we have an unrecognized service, just output the hash that has been returned
        render :text => omniauth.to_yaml
        return
      end
      
      # continue only if provider and uid exist
      if uid != '' and provider != ''

        # nobody can sign in twice, nobody can sign up while being signed in (this saves a lot of trouble)
        if !user_signed_in?

          # check if user has already signed in using this service provider and continue with sign in process if yes
          auth = Service.find_by_provider_and_uid(provider, uid)
          if auth
            flash[:notice] = 'Signed in successfully via ' + provider.capitalize + '.'
            sign_in(:user, auth.user)
            redirect_to current_user
          else
            # check if this user is already registered with this email address; get out if no email has been provided
            if email != ''
              # search for a user with this email address
              existinguser = User.find_by_email(email)
              if existinguser
                # map this new login method via a service provider to an existing account if the email address is the same
                existinguser.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
                flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account ' + existinguser.email + '. Signed in successfully!'
                sign_in(:user, existinguser)
                redirect_to current_user
              else
                # TODO: Do not automatically register user. Send them to a resgistration page
                flash[:notice] = 'You need to create an account to sign in with Facebook'
                redirect_to new_user_registration_path
                # let's create a new user: register this user and add this authentication method for this user
                # name = name[0, 39] if name.length > 39             # otherwise our user validation will hit us

                # new user, set email, a random password and take the name from the authentication service
                # user = User.new :email => email, :password => SecureRandom.hex(10), :fullname => name

                # add this authentication service to our new user
                # user.services.build(:provider => provider, :uid => uid, :uname => name, :uemail => email)

                # do not send confirmation email, we directly save and confirm the new record
                # user.skip_confirmation!
                # user.save!
                # user.confirm!

                # flash and sign in
                # flash[:myinfo] = 'Your account has been created via ' + provider.capitalize + '. In your profile you can change your personal information and add a local password.'
                # sign_in(:user, user)
                # redirect_to current_user
              end
            else
              flash[:error] =  service_route.capitalize + ' can not be used to sign-up as no valid email address has been provided. Please use another authentication provider or use local sign-up. If you already have an account, please sign-in and add ' + service_route.capitalize + ' on your Authentication Services page.'
              redirect_to new_user_session_path
            end
          end
        else
          # the user is currently signed in
        
          # check if this service is already linked to his/her account, if not, add it
          auth = Service.find_by_provider_and_uid(provider, uid)
          if !auth
            current_user.services.create(:provider => provider, :uid => uid, :uname => name, :uemail => email)
            flash[:notice] = 'Sign in via ' + provider.capitalize + ' has been added to your account.'
            redirect_to current_user
          else
          flash[:notice] = service_route.capitalize + ' is already linked to your account.'
              redirect_to current_user
          end  
        end  

      else
        flash[:error] =  service_route.capitalize + ' returned invalid data for the user id.'
        redirect_to new_user_session_path
      end

    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '.'
      redirect_to new_user_session_path
    end
  end
end
