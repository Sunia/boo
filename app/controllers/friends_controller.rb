class FriendsController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  # For adding the new friend. 
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
          if @client.status 
             
             # Check Friends Count of client
             if @client.friend_credit == 0
               render json: {:status => "false", :message => "You have used your all credits. Purchase friend credits to add new friends."} 
             else  
               sms_status = send_request(@client,friend_contact)
               render json: {:status => "true", :message => "Message has been sent to your friend of invitation to use this app"} if sms_status == true
               render json: {:status => "false", :message => "Contact number is not valid or its format is not correct"} if sms_status == false
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
  
  private
  
  def send_request(client,friend_contact)
    @receiver = Client.find_by_contact_number(friend_contact)
    
    # Not in database
    if @receiver.blank?
       #send push notification, call to method.
       send_sms_friend(friend_contact)
    else
      # User is in the database, send request to that user
      @request = Request.create(:sender_id => client.id, :client_id => @receiver.id)
      if !@request.blank?
        "request_send"
      else
        "error"
      end
       
    end
  end
  
  # Friend is not in the database. So send the invitation.
   
  def send_sms_friend(friend_contact)
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    
    if friend_contact[0] != "+"
      false
    else
      begin
        message = client.messages.create from: '+18023326627', to: friend_contact, body: "Hello Boo app admin here..Your friend has invited you to download the boo app"
        message.status == "queued" ? true : false
      rescue Exception => e
       false
      end
    end
  end

  def friend_params
    params.require(:client).permit(:friend_name, :contact_number)
  end
  
end