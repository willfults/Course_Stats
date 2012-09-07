class ForumsController < ApplicationController

def index
    @forums = Forum.where("course_id is NULL")
    @course = Course.new
    if params[:course_id]
		@course = Course.find(params[:course_id])
		@forums = Forum.where(:course_id => @course.id)
    end
 
end

  def show
    @forum = Forum.find(params[:id])
    @course = Course.new
    if @forum.course_id
	@course = Course.find(@forum.course_id)
    end
  end

  def new
	@course = Course.new
	if params[:course_id]
		@course = Course.find(params[:course_id])
	end

    @forum = Forum.new
  end

  
  def create
    @forum = Forum.new(:name => params[:forum][:name], :description => params[:forum][:description], :course_id => params[:forum][:course_id] ) ;
    if @forum.save
		if @forum.course_id
			redirect_to forums_path(:course_id => @forum.course_id ), :notice => "Successfully created course forum."
		else
			redirect_to forums_path, :notice => "Successfully created forum."
		end
    else
      	if @forum.course_id
			redirect_to forums_path(:course_id => @forum.course_id ), :notice => "Error while creating course forum."
		else
			redirect_to forums_path, :notice => "Error while creating forum."
		end
    end
  end


  def edit
    @forum = Forum.find(params[:id])
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(params[:forum])
      redirect_to @forum, :notice  => "Successfully updated forum."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy
    redirect_to forums_url, :notice => "Successfully destroyed forum."
  end
end
