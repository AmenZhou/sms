class SmsOut < ActiveRecord::Base
  def self.save_messages
    remote_messages = get_messages
    local_message = SmsOut.where(to: '+16699995985').order('send_date desc').first
    
    remote_messages.each do |remote|
      if remote.date_sent > local_message.send_date
         SmsOut.create(message_id:remote.sid, from:remote.from, to:remote.to, content:remote.body, send_date:remote.date_sent, status:remote.status)
      end
    end
  end
  
   def self.get_messages    
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token

    # Loop over messages and print out a property for each one
   # messages = @client.account.messages.list
   # messages
    messages = []
    @client.account.messages.list({ to: '+16699995985'}).each do |message| 
      messages <<  message
      puts message.body
    end
  end   
  
  def self.get_message_by_sid(sid)
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new account_sid, auth_token
    
    message = @client.account.messages.get(sid)
    
    return message
  end
  
  def self.is_number_blocked?(number)
    pattern = /[^0-9]/
    number = number.gsub(pattern, "")
    number.insert(0, '+1')
    puts number
    block_message = SmsOut.where(from:number, is_block:true)
    
    
    block_message = SmsOut.where(to:number, is_block:true) if block_message.count == 0
    
    unless block_message.count == 0
      puts "***********#{number} is in the blacklist***************"
      return true
    end
      
    return false
  end
  
  def self.phone_validation?(number)
    pattern = /(\d{3}.?\d{3}.?\d{4}\s?)+/
    if pattern.match(number).to_s != number
      puts "**************错误：电话号码：#{number}--电话号码格式不对****************"
      return false
    end
    true
  end
  
  def self.number_filter(numbers)
    numbers = numbers.split(" ")
    filtered_number = []
    
    numbers.each do |number|
      if phone_validation?(number)
        filtered_number << number unless is_number_blocked?(number)
      end
    end
    
    return filtered_number
  end
end
