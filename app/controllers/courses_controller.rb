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
    @courses = current_user.courses
  end
  
  def my_courses
    @course_histories = current_user.course_histories
    @courses = Course.all
  end
  
  def search
    @courses = Course.search(params[:q])
  end
  
  def video
    @course = Course.find(params[:id])
  end
  
end
