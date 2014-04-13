require 'rubygems'          # This line not needed for ruby > 1.8
require 'twilio-ruby'
class Phone < ActiveRecord::Base

  def self.send_msg content, to_number
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    sms = @client.account.sms.messages.create(:body => content,
        :to => to_number,
        :from => ENV['TWILIO_PHONE'])
    puts sms.body
  end

end
