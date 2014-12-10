class FriendsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
    
  end
  
  def new_friend
    
    friend_contact = params[:client][:contact_number]
    
    if params[:client][:client_id].blank?
      render json: {:status => false, :message => "Please fill the client ID"}
    elsif friend_contact.blank?
      render json: {:status => false, :message => "Please fill the Contact Number"}
    else
      begin
         @client = Client.find(params[:client][:client_id])
         
          # Check Status of the client Details
          if @client.status == true 
             
             # Check Friends Count of client
             if @client.friend_credit == 0
               render json: {:status => false, :message => "You have used your all credits. Purchase friend credits to add new friends."} 
             else  
                send_request(@client,friend_contact)
            end
        else 
            render json: {:status => false, :message => "The client of mentioned ID is not active."}
         end 
              
      rescue Exception => e
        if @client.nil?
          render json: {:status => false, :message => "No client of this ID"}
         else
          render json: {:status => false, :message => "Something wrong has happened"}
         end
      end
      
    end
  end
  
  
  def send_request(client,friend_contact)
    byebug
    @receiver = Client.find_by_contact_number(friend_contact)
    
    # Not in database
    if @receiver.blank?
       #send push notification
       render json: {:status => false, :message => "Friend is not in the database"}
    else
      # User is in the database, send request to that user
       @request = Request.create(:sender_id => client.id, :receiver_id => @receiver.id)
      if !@request.blank?
        render json: {:status => true, :message => "Request has succesfully sent to the user"}
      else
        render json: {:status => false, :message => "Some error has occurred."} 
      end 
        
    end
    
  end
  
  def add_friend
    #@friend = client.friends.create(friend_params)
    #client.update_attribute("friend_credit", @client.friend_credit - 1)
    #render json: {:status => true, "message" => "Friend has succesfully added", :friend_details => JSON.parse(@friend.to_json)}
  end
  
  
  
  private
  def friend_params
    params.require(:client).permit(:friend_name, :contact_number)
  end
  
end
