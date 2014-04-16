require 'rubygems'          # This line not needed for ruby > 1.8
require 'twilio-ruby'
class Phone < ActiveRecord::Base

  def self.send_msg content, to_number
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    max = 160
    to_numbers = to_number.split(" ")
    notice_hash = Hash.new
    notice_arr = Array.new

    to_numbers.each do |to_number|
      if content.length > max
        while(content.length > max)
          cont_split = content[0..(max-1)]
          content = content[max..-1]

          @client = Twilio::REST::Client.new account_sid, auth_token
          #sms = @client.account.sms.messages.create(:body => cont_split,
          #                                          :to => to_number,
          #                                          :from => ENV['TWILIO_PHONE'])
          #puts sms.body 
          notice_hash[:to] = to_number
          notice_hash[:body] = cont_split
          notice_arr << notice_hash
        end
      else
        @client = Twilio::REST::Client.new account_sid, auth_token
        #sms = @client.account.sms.messages.create(:body => content,
        #                                          :to => to_number,
        #                                          :from => ENV['TWILIO_PHONE'])
        #puts sms.body
        notice_hash[:to] = to_number
        notice_hash[:body] = content
        notice_arr << notice_hash
      end
    end
    notice_arr
  end    
end
