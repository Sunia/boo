class VisitorsController < ApplicationController
  
  
  def index
  end

  def select_route
    if current_user
      redirect_to clients_path
    else
      redirect_to visitors_path
    end
  end
end
