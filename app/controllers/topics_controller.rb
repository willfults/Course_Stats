class TopicsController < ApplicationController
  def index
    @topics = Topic.all
    @forum = Topic.first.forum
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = Topic.new
    @forumpost = Forumpost.new
  end

  
  def create
      @topic = Topic.new( :name => params[:topic][:name], :last_poster_id => current_user.id, :last_post_at => Time.now, 
		:forum_id => params[:topic][:forum_id], :user_id => current_user.id)
    
	if @topic.save
		@forumpost = Forumpost.new(:content => params[:forumpost][:content], :topic_id => @topic.id, :user_id => current_user.id)
		@topic = Topic.new(:name => params[:topic][:name], :last_poster_id => current_user.id, :last_post_at => Time.now, 
		:forum_id => params[:topic][:forum_id])

		if@forumpost.save
			flash[:notice] = "Successfully created topic."
			redirect_to "/forums/#{@topic.forum_id}" 
		else
			render 'new'
		end
	else 
		render 'new'
    	end

	
   
  end


  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to "/forums/#{@topic.forum_id}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to "/forums/#{@topic.forum_id}"
  end
end
