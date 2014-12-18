class Message

   def self.send_sms(contact, msg)
     client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
     message = client.messages.create from: '+18023326627', to: contact, body: msg
  end

end