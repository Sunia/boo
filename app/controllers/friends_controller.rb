class FriendsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def new
    
  end
  
  def new_friend
    
    friend_contact = params[:client][:contact_number]
    
    if params[:client][:client_id].blank?
      render json: {:status => "false", :message => "Please fill the client ID"}
    elsif friend_contact.blank?
      render json: {:status => "false", :message => "Please fill the Contact Number"}
    else
      begin
         @client = Client.find(params[:client][:client_id])
         
          # Check Status of the client Details
          if @client.status == true 
             
             # Check Friends Count of client
             if @client.friend_credit == 0
               render json: {:status => "false", :message => "You have used your all credits. Purchase friend credits to add new friends."} 
             else  
               sms_status = send_request(@client,friend_contact)
               render json: {:status => "true", :message => "Message has been sent to your friend of invitation to use this app"} if sms_status == true
               render json: {:status => "true", :message => "Request has succesfully sent to the user"} if sms_status == "request_send"
               render json: {:status => "false", :message => "Some error has occurred."} if sms_status == "error"
            end
        else 
            render json: {:status => "false", :message => "The client of mentioned ID is not active."}
         end 
              
      rescue Exception => e
        if @client.nil?
          render json: {:status => "false", :message => "No client of this ID"}
         else
          render json: {:status => "false", :message => "Something wrong has happened"}
         end
      end
      
    end
  end
  
  
  def send_request(client,friend_contact)
    @receiver = Client.find_by_contact_number(friend_contact)
    
    # Not in database
    if @receiver.blank?
       #send push notification
       return send_sms_friend(friend_contact)
       
    else
      # User is in the database, send request to that user
      byebug
       @request = Request.create(:sender_id => client.id, :client_id => @receiver.id)
      if !@request.blank?
          return "request_send"
      else
        return "error"
         
      end 
    end
    
  end
  
  def add_friend
    #@friend = client.friends.create(friend_params)
    #client.update_attribute("friend_credit", @client.friend_credit - 1)
    #render json: {:status => true, "message" => "Friend has succesfully added", :friend_details => JSON.parse(@friend.to_json)}
  end
  
  def send_sms_friend(friend_contact)
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.messages.create from: '+18023326627', to: friend_contact, body: "Hello Boo app admin here..Your friend has invited you to download the boo app"
    
    return true
  end
  
  
  private
  def friend_params
    params.require(:client).permit(:friend_name, :contact_number)
  end
  
end
