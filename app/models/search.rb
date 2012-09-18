class Search < ActiveRecord::Base
  def self.search(params)
    Tire.search  do
    #tire.search :per_page => 2, :page => 1 do
      query do
        boolean do
          must { string params[:query], default_operator: "AND" } if params[:query].present?
          must { string "*", default_operator: "AND" } if !params[:query].present?
          must { term :course_rating, params[:course_rating] } if params[:course_rating].present?
          must { term :user_id, params[:author] } if params[:author].present?
          must { term :category, params[:industry] } if params[:industry].present?
        end
        page = (1 || 1).to_i
        
        
      end
      # User from and size for pagination
      #from 3
      #size 2
      # raise to_curl
    end
  end
end