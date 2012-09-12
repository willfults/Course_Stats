require 'rubygems'
require 'linkedin'

class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_user,   only: [:edit, :update, :crop, :dashboard, :achievements, :stats]
  before_filter :admin_user,     only: :destroy
  
  def dashboard
    @user = User.find(params[:id])
    # we will be doing something here later
  end

  def achievements
    @user = User.find(params[:id])
    # we will be doing something here later
  end

  def stats
    @user = User.find(params[:id])
    # we will be doing something here later
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @avatar = Avatar.new
    if @user.avatar? 
      @avatar = Avatar.find(@user.avatar)
    end
    if request.path != user_path(@user)
      redirect_to @user, status: :moved_permanently
    end
    linkedin_profile
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update    
    if @user.update_attributes(params[:user])
      sign_in @user
      if params[:user][:image].present?
        render :crop
      else
        flash[:success] = "Profile updated"
        redirect_to @user
      end
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user == (@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def linkedin_profile
      @profile = LinkedinProfile.find_by_user_id(@user.id);
      @linkedin_profile = LinkedinProfile.new
      if $LINKEDIN_HASH
        token = $LINKEDIN_HASH["credentials"]["token"]
        secret = $LINKEDIN_HASH["credentials"]["secret"]
        client = LinkedIn::Client.new($LINKEDIN_APP_KEY, $LINKEDIN_APP_SECRET)
        client.authorize_from_access(token, secret)
        linkedin = client.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions, :public_profile_url])
        @linkedin_profile.name = linkedin[:first_name] + " " + linkedin[:last_name]
        @linkedin_profile.headline = linkedin[:headline]
        @linkedin_profile.summary = linkedin[:summary]
        @linkedin_profile.public_profile_url = linkedin[:public_profile_url]
        @linkedin_profile.user_id = @user.id
      end
    end

end
