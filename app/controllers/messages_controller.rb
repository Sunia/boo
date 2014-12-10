class MessagesController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def new
    
  end

  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    random_code = rand.to_s[2..6]

    if params["user"]["contact_number"].blank?
      render json: {:status => "false", :body => "Contact number is blank"}
    else
      begin 
         message = client.messages.create from: '+18023326627', to: params["user"]["contact_number"], body: "Hello Its boo app justification !!!! Please verify the code #{random_code} to get the access. "
         if message.status == "queued"
           @client = Client.create(:contact_number => params["user"]["contact_number"])
           render json: {:status => true, :message => "Message has been sent sucessfully", :code_sent => random_code, :client_id => @client.id } 
         end
         
       rescue Exception => e
         render json: {:status => "false", :body => "Something went wrong"}
      end
    end
    
  end

# with parameters 
#curl --basic --header "Content-Type:application/json" --header "Accept:application/json" http://localhost:3000/messages/notify -X POST -d ' {"user": {"contact_number": "+918872853171"}}'
#RestClient.post 'http://localhost:3000/messages/notify', {:user => {:contact_number => "+918872853171"}}
end