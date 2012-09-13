class StatisticsController < ApplicationController
  before_filter :authenticate_user!, :is_creator
  
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
        combine_stat_data(stat,play_data,completion_data)
      end
      #@play_data = create_json(play_data)
      #@completion_data = create_json(completion_data)
      
      @start_date = start_date.strftime("%m-%d-%Y")
      @end_date = end_date.strftime("%m-%d-%Y")
      @chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({ :text=> "Statistics"})
        f.options[:xAxis][:categories] = get_dates_for_graph(play_data)    
        f.series(:type=> 'spline',:name=> 'Views', :data=> play_data.values)
        f.series(:type=> 'spline',:name=> 'Completions', :data=> completion_data.values)
        f.options[:chart][:width] = 1200
      end
  end
   
  private 
  
    def combine_stat_data(stat,play_data, completion_data)
        date_of_stat = stat.created_at.strftime("%Y-%m-%d")
        #if same day...
        date_int = DateTime.parse(date_of_stat).to_i
        if stat.status == "play"
          @play_count += 1
          if play_data.has_key?(date_int)
            play_data[date_int] = play_data[date_int] + 1
          else
            play_data[date_int] = 1;
            if !completion_data.has_key?(date_int)
              completion_data[date_int] = 0;
            end
          end
        else
          @completion_count += 1
          if completion_data.has_key?(date_int)
            completion_data[date_int] = completion_data[date_int] + 1
          else
            completion_data[date_int] = 1;
            if !play_data.has_key?(date_int)
              play_data[date_int] = 0;
            end
          end
        end
    end
    
    #returns array of dates
    def get_dates_for_graph(play_data)
      dates = Array.new
      index = 0
      play_data.keys.each do |key| 
         dates[index] = Time.at(key).strftime("%m-%d-%Y")
         index += 1
      end
      dates
    end
  
    def is_creator
      @course = Course.find(params[:id])
      #check to see if the user is the creator of the course or an admin, if not disallow access
      if @course.user_id != current_user.id 
          redirect_to home_path
      end
    end

end
