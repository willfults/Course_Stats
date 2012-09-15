class CoursesController < ApplicationController
  before_filter :authenticate_user!
  
  autocomplete :tag, :name, :class_name => 'ActsAsTaggableOn::Tag' # <- New
  
  def index
    @courses = Course.all
  end
  
  def edit
    @course = Course.find(params[:id])
  end
  
  def show
      @course = Course.find(params[:id])
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @course }
      end
  end
   
  def start
      @course = Course.find(params[:id])
      @statistics = Statistic.where(:user_id => current_user.id).where(:course_id => @course.id).where(:status => "done")
      
      @course_history = current_user.course_histories.where(:course_id => @course.id).first
      
      if !@course_history
        @course_history = current_user.course_histories.build(:course_id => @course.id, :status => "in_progress")
        @course_history.save
      end
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @course }
      end
  end 
   
  def new
    @course = Course.new
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end
  
  def create
    @course = current_user.courses.build(params[:course])
    if @course.save
      flash[:success] = "Course created!"
      redirect_to edit_course_path(@course);
    else
      render 'new'
    end
  end
  
  def update
      @course = current_user.courses.where(:id => params[:id]).first
      
      # Is there a better way of doing this?
      if params[:publish] 
        @course.published = true
      elsif params[:un_publish]
        @course.published = false
      end 
      
      if @course.update_attributes(params[:course])
         flash[:success] = "Course saved!"
         redirect_to edit_course_path(@course);
      else
         render :action => 'edit'
      end
   end

  def destroy
    @course = current_user.courses.where(:id => params[:id]).first
    if @course.present?
      @course.destroy
      flash[:success] = "Course deleted!"
    end
    # in both cases, redirect to root_path
    redirect_to courses_path
  end
  
  def manage
    set_admin_mode(true)
    @courses = current_user.courses
  end
  
  def my_courses
    set_admin_mode(false)
    @course_histories = current_user.course_histories
    @bookmarks = current_user.bookmarks
  end
  
  def search
    if(params[:query].empty?)
      @courses = Course.where("published = 1 and privacy='Public'")
    else
      @facets = Course.facets(params)
      @courses = Course.search(params)
    end
  end
  
  def video
    @course = Course.find(params[:id])
  end
  
  def rate
    @course = Course.find(params[:id])
    @course.rate(params[:stars], current_user, params[:dimension])
    respond_to do |format|
      format.js
    end
  end
  
  def bookmark
    puts request.method
    if params[:remove]
      bookmark = current_user.bookmarks.where(:course_id => params[:id]).first
      bookmark.destroy
    else
      bookmark = current_user.bookmarks.build(:course_id => params[:id])
      bookmark.save
    end
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to my_courses_path }
    end

  end
  
end
