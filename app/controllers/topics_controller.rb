class TopicsController < ApplicationController
  def index
    @topics = Topic.all
    @forum = Topic.first.forum
  end

  def show
    @topic = Topic.find(params[:id])
    @forum = Forum.find(@topic.forum)
    @course = Course.new
    if @forum.course_id
	@course = Course.where(:id=>@forum.course_id)
    end
  end

  def new
    @topic = Topic.new
    @course = Course.new
    @forum = Forum.find(params[:forum_id])
   if @forum.course_id
	@course = Course.where(:id=>@forum.course_id)
    end
    @forumpost = Forumpost.new
  end

  
  def create
      @topic = Topic.new( :name => params[:topic][:name], :last_poster_id => current_user.id, :last_post_at => Time.now, 
		:forum_id => params[:topic][:forum_id], :user_id => current_user.id)

	@forum = Forum.find(params[:topic][:forum_id])
    
	if @topic.save
		@forumpost = Forumpost.new(:content => params[:topic][:description], :topic_id => @topic.id, :user_id => current_user.id)
		@topic = Topic.new(:name => params[:topic][:name], :last_poster_id => current_user.id, :last_post_at => Time.now, 
		:forum_id => params[:topic][:forum_id])

		if@forumpost.save
			redirect_to show_forum_path(:id => @topic.forum_id ), :notice => "Successfully created forum topic."
		else
			redirect_to show_forum_path(:id => @topic.forum_id ), :notice => "Error while creating forum topic."
		end
	else 
		redirect_to show_forum_path(:id => @topic.forum_id ), :notice => "Error while creating forum topic."
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
