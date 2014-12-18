class ClientsController < ApplicationController
  
  skip_before_action :verify_authenticity_token, :only => [:update_info]
  
  # for listing all the clients.  
  def index
    if current_user
      @clients = Client.all.order(:id)
    else
      flash[:notice] = "First Login to view the client Details"
      redirect_to new_user_session_path
    end
  end
  
  # To update the clients information.
  def update_info
    if params["client"]["id"].blank?
      render json: {:status => "false", :id => "ID should not be blank"}
    else
     begin
       @client  = Client.find(params["client"]["id"])
       if !@client.status
         render json: {:status => false, :message => "Status is not active. Please verify the code first."}
       else
         @client.update_attributes(client_params)
         render json: {:status => "true", :client_details => JSON.parse(@client.to_json)}
       end
     rescue Exception => e
       if @client.nil?
         render json: {:status => false, :message => "There is no any client regarding this id"}
       else
        render json: {:status => "There is some error"}
       end
     end
    end
  end

  # For deleting the record.
  def destroy
    begin
      @client = Client.find(params[:id])
      @client.destroy
    rescue Exception => e
      flash[:notice]= "There is no any client regarding this ID."
    end
      redirect_to clients_path
  end

  # To show the record of the client.
  def show
    @client = Client.find(params[:id])
  end

  private
  
  def client_params
    params.require(:client).permit(:name, :contact_number, :nick_name, :gender)
  end

end
