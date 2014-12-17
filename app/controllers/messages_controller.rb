class MessagesController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    random_code = rand.to_s[2..6]

    if params["client"]["contact_number"].blank?
      render json: {:status => "false", :body => "Contact number is blank"}
    else
      begin 
         message = client.messages.create from: '+18023326627', to: params["client"]["contact_number"], body: "Hello Its app verification !!!! Please verify the code #{random_code} to get the access. "
         if message.status == "queued"
           @client = Client.find_or_create_by(:contact_number => params["client"]["contact_number"])
           render json: {:status => "true", :message => "Message has been sent sucessfully", :code_sent => random_code, :client_id => @client.id } 
         end
         
       rescue Exception => e
         render json: {:status => "false", :body => "Something went wrong"}
      end
    end
    
  end

end