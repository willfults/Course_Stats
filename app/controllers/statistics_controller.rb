class StatisticsController < ApplicationController
  layout "full_center_layout"
  before_filter :authenticate_user!, :isCreator
  
  def index
    @course_modules = @course.course_modules
  end
  
  def show
      start_date = Time.now - 1.month
      end_date = Time.now
      if params[:start_date].present? 
        start_date = Chronic.parse(params[:start_date])
      end
      if params[:end_date].present? 
        end_date = Chronic.parse(params[:end_date])
      end
      statistics = Statistic.ordered.where(:course_id => @course.id).where(:class_id => params[:class_id]).where(:created_at.gte => start_date).where(:created_at.lte => end_date)
      @play_count = 0
      @completion_count = 0
      play_data = Hash.new
      completion_data = Hash.new
      statistics.each do |stat| 
      if stat.status == "play"
          @play_count += 1
          combine_stat_data(stat,play_data)
        else
          @completion_count += 1
          combine_stat_data(stat,completion_data)
        end
      end
      @play_data = create_json(play_data)
      @completion_data = create_json(completion_data)
      
      @start_date = start_date.strftime("%m-%d-%Y")
      @end_date = end_date.strftime("%m-%d-%Y")
  end
   
  private 
  
    def combine_stat_data(stat,stat_data)
        date_of_stat = stat.created_at.strftime("%Y-%m-%d")
        #if same day...
        date_int = DateTime.parse(date_of_stat).to_i
        if stat_data.has_key?(date_int)
          stat_data[date_int] = stat_data[date_int] + 1
        else
          stat_data[date_int] = 1;
        end
    end
  
  
    def create_json(stat_data)
      graph_data = "["
      stat_data.each do|key,value|
        graph_data += "{x: " + key.to_s + ",y:" + value.to_s + "},"
      end
      graph_data +=  "]"
    end
    
    def isCreator
      @course = Course.find(params[:id])
      #check to see if the user is the creator of the course or an admin, if not disallow access
      if @course.user_id != current_user.id 
          redirect_to home_path
      end
    end

end
