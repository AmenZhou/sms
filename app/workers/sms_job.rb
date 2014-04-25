module SmsJob
  @queue = :high
  
  def self.perform content, to_number
    #debugger
    #puts 'abc'
    #debugger
    pattern = /(\d{10}\s?)+/
    unless pattern.match(to_number)
      return puts "invalidate number"
    end
    account_sid = ENV['TWILIO_ID']
    auth_token = ENV['TWILIO_TOKEN']
    max = 69
    to_numbers = to_number.split(" ")
    notice_arr = Array.new
    content_temp = content

    to_numbers.each do |number|
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
      puts notice_arr
  end
end
