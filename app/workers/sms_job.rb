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
  
  def self.perform content, numbers
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    max = 69
    unsubscribe_str = '(Reply N to unsubscribe this message)'
    content = content + unsubscribe_str
    content_temp = content
    url = ENV['TWILIO_CALLBACK_URL']
    
    numbers.each do |number|

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
        
        sleep(5)
      end
      content = content_temp
    end
  end
end
