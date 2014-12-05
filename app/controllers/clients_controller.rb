class ClientsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def new
  end
  
  def index
    if current_user
      @clients = Client.all
    else
      flash[:notice] = "First Login to view the User Details"
      redirect_to new_user_session_path
    end
  end

  def update_info
      if params["user"]["id"].blank?
        render json: {:status => "false", :id => "ID should not be blank"}
      else
       begin
        @client  = Client.find(params["user"]["id"])
        @client.update_attributes(client_params)
        @client.update_attributes(:status => true)
        puts "Hello"
        render json: {:status => "true", :client_details => JSON.parse(@client.to_json)}
      rescue Exception => e
        render json: {:status => "There is some error"}
      end
    end
  end
  
  private
  def client_params
    params.require(:user).permit(:name, :contact_number, :nick_name, :gender)
  end
  
end

#curl --basic --header "Content-Type:application/json" --header "Accept:application/json" http://localhost:3000/clients/update_info -X POST -d '{"user": {"id" : "1","name" : "Sunia", "nick_name":"arohi", "contact_number": "+918872853171", "gender" : "female"}}'

#RestClient.post 'http://localhost:3000/clients/update_info', {:user => {:id => "1",:name => "Sunia", :nick_name =>"arohi", :contact_number => "+918872853171", :gender => "female"}}
