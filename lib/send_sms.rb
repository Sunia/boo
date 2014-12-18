class SendSms
  def initialize
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
  end

  def send_sms(contact, msg)
    @client.messages.create(from: Rails.application.secrets.twilio_contact, to: contact, body: msg)
  end

end