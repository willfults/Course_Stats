class CourseModulesController < ApplicationController
  before_filter(:get_class)
  
    
  def get_class
      @course = Course.find(params[:course_id])
  end
  
  def index
    @course_modules = @course.course_modules
  end
  
  def new
    @course_module = CourseModule.new
    @course_module.class_type = params[:type]
    
    if @course_module.class_type == "Quiz" 
      quiz = @course_module.build_quiz
      question = quiz.quiz_questions.build
      4.times { question.quiz_answers.build }
    end
  
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @question }
    end
  end

  def create
    @course = current_user.courses.where(:id => params[:course_id]).first
    @lastModule = @course.course_modules.last
    
    @course_module = @course.course_modules.build(params[:course_module])
    
    if params[:add_question]
      # add empty ingredient associated with @recipe
      question = @course_module.quiz.quiz_questions.build
      4.times { question.quiz_answers.build }
      render 'new'
    else 
      if @lastModule 
        @course_module.position = @lastModule.position + 1 
      else
        @course_module.position = 1
      end
    
      if @course_module.save
        flash[:success] = "Class created!"
        redirect_to course_course_modules_path(@course)
      else
        render 'new'
      end
    end
    
  end
  
  def edit
    get_class
    @course_module = @course.course_modules.where(:id => params[:id]).first
    
    render 'edit'
  end
  
  def update
      @course = current_user.courses.where(:id => params[:course_id]).first
      @course_module = @course.course_modules.where(:id => params[:id]).first
      
      if params[:add_question]
        # add empty ingredient associated with @recipe
        question = @course_module.quiz.quiz_questions.build
        4.times { question.quiz_answers.build }
        render 'edit'
      else 
        if @course_module.update_attributes(params[:course_module])
           redirect_to course_course_modules_path(@course);
        else
           render :action => 'edit'
        end
      end
   end

  def show
      get_class()
      @course_module = @course.course_modules.where(:id => params[:id]).first
      @course_history = current_user.course_histories.where(:course_id => @course.id).first
      
      @course_module_history = @course_history.course_module_histories.where(:course_module_id => @course_module.id).first
      
      if !@course_module_history
        @course_module_history = @course_history.course_module_histories.build(:course_module_id => @course_module.id, :status => "in_progress")
        @course_module_history.save
      end
      
      if @course_module.class_type == "Video" || @course_module.class_type == "Audio" 
        render 'show'
      elsif @course_module.class_type == "Image"
        update_module_as_complete @course_module_history
        render 'image'        
      elsif @course_module.class_type == "Quiz"
        render 'quiz'        
      end
   end

  def destroy
    @course = current_user.courses.where(:id => params[:course_id]).first
    @courseModule = @course.course_modules.where(:id => params[:id]).first
    if @courseModule.present?
      @courseModule.destroy
      flash[:success] = "Course deleted!"
    end
    # in both cases, redirect to root_path
    redirect_to course_course_modules_path(@course)
  end
  
  def quiz_answers
    get_class()
    @course_module = @course.course_modules.where(:id => params[:id]).first
    quiz = @course_module.quiz
    quiz_questions = quiz.quiz_questions
    
    @correctAnswers = 0
    quiz_questions.each do |question|
      correctAnswer = question.quiz_answers.where(:correct_answer => true).first
      answer = params["question_" + question.id.to_s]
      if correctAnswer.id.to_s == answer
        @correctAnswers += 1
      end
    end
    
    if quiz.passing_score <= @correctAnswers
      course_history = get_course_history @course.id
      course_module_history = get_course_module_history course_history, @course_module.id
      update_module_as_complete(course_module_history)
    end
    
    render 'quiz_results'
  end
  
  # AJAX POST - courses/:course_id/course_modules/:id/:status/
  def update_stat
    class_id = params[:id]
    course_id = params[:course_id]
    action = params[:status]
    if action == 'done'
      
      course_history = get_course_history course_id
      course_module_history = get_course_module_history course_history, class_id
      update_module_as_complete(course_module_history)
      
      Statistic.create(
        class_id: class_id.to_i,
        course_id: course_id.to_i,
        user_id: current_user.id,
        action: action.to_str
      )
    else
      Resque.enqueue(StatCollector, class_id.to_i, course_id.to_i, current_user.id, action)
    end
    render :nothing => true
  end
  
  def update_module_as_complete(course_module_history)
    course_module_history.status = "completed"
    course_module_history.save
    
    course_history = course_module_history.course_history
    
    course_modules_size = course_history.course_module_histories.size
    course_modules_completed_size = course_history.course_module_histories.where(:status => "completed").size
    
    if course_modules_size == course_modules_completed_size 
      course_history.status = "completed"
      course_history.save
    end
  end
    
  def get_course_history(course_id)
      current_user.course_histories.where(:course_id => course_id).first
  end
  
  def get_course_module_history(course_history, module_id)
      course_history.course_module_histories.where(:course_module_id => module_id).first
  end

  def next
    get_class
    @course_module = @course.course_modules.where(:id => params[:id]).first   
    course_history = get_course_history(@course.id)
    course_module_history = get_course_module_history(course_history, @course_module)
    
    # THIS CODE COULD BE SIMPLER IF WE GUARENTEE MODULE POSITIONS ARE SEQUENTIAL. 
    position_in_modules = 0
    if course_module_history.status != "completed"
      redirect_to course_course_module_path(@course, @course_module), :flash => { :error => "You have not completed this module." }
    else
      @course.course_modules.each_with_index do |course_module, index|
        if @course_module.position == course_module.position
          position_in_modules = index
          break
        end
      end
      
      if @course.course_modules.size == position_in_modules+1
        redirect_to course_path(@course) + "/start"
      else
        redirect_to course_course_module_path(@course, @course.course_modules[position_in_modules+1])
      end
    end
      
  end
  
  def previous
    get_class
    @course_module = @course.course_modules.where(:id => params[:id]).first   
    course_history = get_course_history(@course.id)
    course_module_history = get_course_module_history(course_history, @course_module)
    
    # THIS CODE COULD BE SIMPLER IF WE GUARENTEE MODULE POSITIONS ARE SEQUENTIAL. 
    position_in_modules = 0
    @course.course_modules.each_with_index do |course_module, index|
      if @course_module.position == course_module.position
        position_in_modules = index
        break
      end
    end
    
    if position_in_modules == 0
      redirect_to course_path(@course) + "/start"
    else
      redirect_to course_course_module_path(@course, @course.course_modules[position_in_modules-1])
    end
      
  end
end
