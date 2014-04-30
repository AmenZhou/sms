require 'rubygems'          # This line not needed for ruby > 1.8
require 'twilio-ruby'
class Phone < ActiveRecord::Base
  def self.phone_validation?(number)
    pattern = /(\d{3}.?\d{3}.?\d{4}\s?)+/
    if pattern.match(number).to_s != number
      puts "invalid phone number"
      return false
    end
    true
  end
  #this method is instead of sms_job in works directory 
  def self.sms_send content, to_number
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    max = 69
    to_numbers = to_number.split(" ")
    notice_arr = Array.new
    content_temp = content

    to_numbers.each do |number|
      next unless phone_validation?(number)
      while(content.length > 0)
        if content.length > max
          cont_split = content[0..(max-1)]
          content = content[max..-1]
        else
          cont_split = content
          content = ""
        end
        @client = Twilio::REST::Client.new account_sid, auth_token
        sms = @client.account.sms.messages.create(:body => cont_split,
                                                  :to => number,
                                                  :from => ENV['TWILIO_PHONE'])
        puts sms.body 

        notice_hash = Hash.new
        notice_hash[:to] = number
        notice_hash[:body] = cont_split
        notice_arr << notice_hash
        puts notice_hash
        sleep(5)
      end
      content = content_temp
    end
      #puts notice_arr
    #notice_arr
  end 
  
  #
  def self.get_messages    
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    
    # Loop over messages and print out a property for each one
    messages = @client.account.messages.list
    messages
  end    
end    
