class MessagesController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  
  def new
    
  end

  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    random_code = rand.to_s[2..6]

    if params["user"]["contact_number"].blank?
      render json: {:status => "false", :body => "Contact number is blank"}
    elsif params["user"]["contact_number"] != "+918872853171"
      render json: {:status => "false", :body => 'The number on which you want to send message is not verified.'}
    else
      
      begin 
         message = client.messages.create from: '+12053169104', to: params["user"]["contact_number"], body: "Hello Sunia Kalra here !! Please verify the code #{random_code} "
         if message.status == "queued"
           @client = Client.create
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


#=============================================================================
# Without parameters

  # def notify
    # client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    # message = client.messages.create from: '+12053169104', to: '+918872853171', body: 'Yippie.'
    # render json: {:status => true, :message => "Message has sent sucessfully" } 
# end

#curl --data "foo=bar" http://localhost:3000/messages/notify
#RestClient.post 'http://localhost:3000/messages/notify', {:foo => "bar"}

end