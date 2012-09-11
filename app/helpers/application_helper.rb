module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def notice
    flash[:notice]
  end

  def alert
    flash[:alert]
  end
  
  def activate_menu(menu_class, selected_menu)
    class_list = menu_class
    class_list += (selected_menu == menu_class) ? " active" : ""
  end
  
end