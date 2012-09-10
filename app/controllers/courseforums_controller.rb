class CourseforumsController < ApplicationController

  def index
    @courseforums = Courseforum.all
  end

  def show
    @courseforum = Courseforum.find(params[:id])
  end

  def new
  	@course = Course.find(params[:id])
     	@forum = Forum.new
  end
 
  
  def create
    @course = Course.find(params[:courseforum][:course_id])
    @forum = Forum.new(:name => params[:courseforum][:forum][:name], :description => params[:courseforum][:forum][:description] )
	
	if @forum.save
		@courseforum = Courseforum.new( :course_id => @course.id, :forum_id => @forum.id )

    		if @courseforum.save
      		redirect_to @courseforum, :notice => "Successfully created course forum."
    		else
      		render :action => 'new'
    		end
	else 
		render :action => 'new'
  	end
  end


  def edit
    @courseforum = Courseforum.find(params[:id])
  end

  def update
    @courseforum = Courseforum.find(params[:id])
    if @courseforum.update_attributes(params[:courseforum])
      redirect_to @courseforum, :notice  => "Successfully updated course forum."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @courseforum = Courseforum.find(params[:id])
    @courseforum.destroy
    redirect_to courseforums_url, :notice => "Successfully destroyed course forum."
  end
end
