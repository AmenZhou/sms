module SmsJob
  @queue = :high
  
  def self.phone_validation?(number)
    pattern = /(\d{3}.?\d{3}.?\d{4}\s?)+/
    if pattern.match(number).to_s != number
      puts "invalid phone number"
      return false
    end
    true
  end
  
  def self.perform content, to_number
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    max = 69
    to_numbers = to_number.split(" ")
    notice_arr = Array.new
    content_temp = content
    message_count = 0
    url = 'http://amen-rails-65165.use1.nitrousbox.com/'
    
   to_numbers.each do |number|
      unless phone_validation?(number)
        #notice << "错误：电话号码：#{number}--电话号码格式不对<br/>"
        puts "错误：电话号码：#{number}--电话号码格式不对<br/>"
        next
      end
      while(content.length > 0)

        if content.length > max
          cont_split = content[0...max]
          content = content[max..-1]
        else
          cont_split = content
          content = ""
        end

        @client = Twilio::REST::Client.new account_sid, auth_token
        sms = @client.account.sms.messages.create(:body => cont_split,
                                                 :to => number,
                                                :from => ENV['TWILIO_PHONE'],
          :status_callback => url + 'send_callback/')
        puts "接收号码: #{number}, 短信内容: #{cont_split}<br/>" 
        #message_count += 1
        
        #if message_count >= 50
        #  SmsOut.save_messages 
        #  message_count = 0
        #end
        #notice << "接收号码: #{number}, 短信内容: #{cont_split}<br/>"
        
        sleep(5)
      end
      content = content_temp
    end
  #  SmsOut.save_messages
   # notice
  end
end
