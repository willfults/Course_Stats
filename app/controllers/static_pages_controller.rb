
class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(page: params[:page])
      if current_user.avatar? 
        @avatar = Avatar.find(current_user.avatar)
    end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
