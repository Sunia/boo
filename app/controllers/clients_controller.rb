class ClientsController < ApplicationController
  
  skip_before_action :verify_authenticity_token, :only => [:update_info]
  # For creating new User
  def new
    @user = Client.new
  end
  
  def create
    begin
      contact = params[:user][:contact_number]
      if contact.to_i.to_s != contact
         flash[:notice] = "Enter integer value of contact number"
         render 'new'
       else
        @client = Client.create(client_params)
        redirect_to clients_path
       end
    rescue Exception=>e
      flash[:notice] = "Something went wrong"
      render 'new'
    end
  end
  
  
  # for listing all the users.  
  def index
    if current_user
      @clients = Client.all.order(:id)
    else
      flash[:notice] = "First Login to view the User Details"
      redirect_to new_user_session_path
    end
  end
  
  # To update the clients information.
  
  def update_info
    if params["user"]["id"].blank?
      render json: {:status => "false", :id => "ID should not be blank"}
    else
     begin
       @client  = Client.find(params["user"]["id"])
       @client.update_attributes(client_params)
       @client.update_attributes(:status => true)
       render json: {:status => "true", :client_details => JSON.parse(@client.to_json)}
     rescue Exception => e
       render json: {:status => "There is some error"}
     end
    end
  end
  
  def destroy
    begin
      @client = Client.find(params[:id])
      @client.destroy
    rescue Exception => e
      flash[:notice]= "There is no any client regarding this ID."
    end
      redirect_to clients_path
  end
  
  private
  def client_params
    params.require(:user).permit(:name, :contact_number, :nick_name, :gender)
  end
  
end
