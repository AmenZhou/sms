class SmsOut < ActiveRecord::Base
  def self.save_messages
    remote_messages = Phone.get_messages
    local_messages = SmsOut.order('created_at desc').limit(50)
    
    remote_messages.each do |remote|
      is_exist = false
      local_messages.each do |local|
        if local.message_id == remote.sid
          is_exist = true
          break
        end
      end
      SmsOut.create(message_id:remote.sid, from:remote.from, to:remote.to, content:remote.body, send_date:remote.date_sent, status:remote.status) unless is_exist
    end
  end
end
