# app/controllers/posts_controller.rb

class ForumpostsController < ApplicationController
  def index
    @forumposts = Forumpost.all
  end

  def show
    @forumpost = Forumpost.find(params[:id])
  end

  def new
    @forumpost = Forumpost.new
    @topic = Topic.new
  end


  def create
   @forumpost = Forumpost.new(:content => params[:forumpost][:content], 
	:topic_id => params[:forumpost][:topic_id], :user_id => current_user.id)
   if @forumpost.save
	@topic = Topic.find(@forumpost.topic_id)
	@topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
	flash[:notice] = "Successfully created post."
      redirect_to "/topics/#{@forumpost.topic_id}"
    else
      render :action => 'new'
    end
  end


  def edit
    @forumpost = Forumpost.find(params[:id])
  end

  def update
    @forumpost = Forumpost.find(params[:id])
    if @forumpost.update_attributes(params[:forumpost])
	@topic = Topic.find(@forumpost.topic_id)
	@topic.update_attributes(:last_poster_id => current_user.id, :last_post_at => Time.now)
	flash[:notice] = "Successfully updated forumpost."
      redirect_to forums_url 
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forumpost = Forumpost.find(params[:id])
    @forumpost.destroy
    redirect_to forumposts_url, :notice => "Successfully destroyed forumpost."
  end
end
