class VisitorsController < ApplicationController
  
  def index
    if current_user
      redirect_to clients_path
    end
  end


end
