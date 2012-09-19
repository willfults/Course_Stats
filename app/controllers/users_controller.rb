require 'rubygems'
require 'linkedin'
require 'koala'

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
  
  def facebook_friends
    facebook_profile
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
    facebook_profile
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
      if session[:linkedin_credentials]
        token = session[:linkedin_credentials]['token']
        secret = session[:linkedin_credentials]['secret']
        client = LinkedIn::Client.new($LINKEDIN_APP_KEY, $LINKEDIN_APP_SECRET)
        client.authorize_from_access(token, secret)
        linkedin = client.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions, :public_profile_url])
        @linkedin_profile.name = linkedin[:first_name] + " " + linkedin[:last_name]
        @linkedin_profile.headline = linkedin[:headline]
        @linkedin_profile.summary = linkedin[:summary]
        @linkedin_profile.public_profile_url = linkedin[:public_profile_url]
        @linkedin_profile.user_id = @user.id
        educations = Array.new
        educations_hash = linkedin[:educations]
        educations_hash[:all].each do |school|
          education = LinkedinEducation.new
          if school[:start_date] && school[:start_date][:year]
            start_year = school[:start_date][:year]
            education.start_date = Date.new(start_year, 1, 1)
          end
          if school[:end_date] && school[:end_date][:year]
            end_year = school[:end_date][:year]
            education.end_date = Date.new(end_year, 1, 1)
          end
          education.degree = school[:degree]
          education.field_of_study = school[:field_of_study]
          education.school_name = school[:school_name]
          educations << education
        end
        @linkedin_profile.linkedin_educations = educations
        positions_hash = linkedin[:positions]
        positions = Array.new
        positions_hash[:all].each do |company|
          position = LinkedinPosition.new
          if company[:start_date] && company[:start_date][:year]
            start_year = company[:start_date][:year]
            start_month = company[:start_date][:month]
            position.start_date = Date.new(start_year, start_month, 1)
          end
          if company[:end_date] && company[:end_date][:year]
            end_year = company[:end_date][:year]
            end_month = company[:end_date][:month]
            position.end_date = Date.new(end_year, end_month, 1)
          end
          position.is_current = company[:is_current]
          position.company_name = company[:company][:name]
          position.industry = company[:company][:industry]
          position.title = company[:title]
          position.summary = company[:summary]
          positions << position
        end
        @linkedin_profile.linkedin_positions = positions
        
      end
    end
    
    def facebook_profile
      if session[:facebook_credentials]
        oauth_access_token = session[:facebook_credentials][:token]
        graph = Koala::Facebook::API.new(oauth_access_token)
        @facebook_profile = graph.get_object("me")
        @facebook_friends = graph.get_connections("me", "friends")
        @facebook_friends.each do |f|
          f[:image] = graph.get_picture(f["id"])
        end

      end
    end

end
