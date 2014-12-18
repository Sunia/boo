class MessagesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def notify
    random_code = rand.to_s[2..6]
    contact = params["client"]["contact_number"]
    if contact.blank?
      render json: {:status => "false", :body => "Contact number is blank"}
    else
      begin
         msg = "Hello Its app verification !!!! Please verify the code #{random_code} to get the access."
         sms_client = SendSms.new
         message = sms_client.send_sms(contact, msg)

         if message.status == "queued"
           @client = Client.find_or_create_by(:contact_number => contact)
           @client.update_attribute("code" , random_code)
           render json: {:status => "true", :message => "Message has been sent sucessfully", :code_sent => random_code, :client_id => @client.id } 
         else
           render json: {:status => false, :message => "Message did not send due to some error"}
         end
      rescue Exception => e
         render json: {:status => "false", :body => "Something went wrong"}
      end
    end
  end

  def verify
     begin
       @client = Client.find(params[:client][:client_id])
       if @client.code == (params[:client][:code]).to_i
         @client.update_attributes(:status => true)
         render json: {:status => "true", :message => "Client has been activated. Please update the Client details form."}
       else
         render json: {:status => "false", :message => "Verification code is not correct. Please update the correct one to activate your services."}
       end
     rescue Exception => e
       if @client.nil?
        render json: {:status => false, :message => "There is no any client regarding this ID."}
       else
         render json: {:status => false, :message => "Something went wrong."}
       end
     end
  end

end