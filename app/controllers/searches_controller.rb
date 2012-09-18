class SearchesController < ApplicationController

  def index
    
      # Facets need to be queried seperately for each model type.
      @facets = Course.facets(params)
      
      @courses = Search.search(params)
    
  end
  
end