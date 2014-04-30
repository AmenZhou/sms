class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    Resque.enqueue SmsJob, params[:message_body], params[:send_number]
   # Phone.sms_send params[:message_body], params[:send_number]
    flash[:notice] = '正在发送...发送时间比较长，耐心等待。'#String.new
    #notice_arr.each do |notice|
      #flash[:notice] << "Send message to #{notice[:to]}, message content is: #{notice[:body]}.||  "
    #end
    flash.keep
    redirect_to action: :index
  end
  
  def message_list
    @messages = Phone.get_messages
  end
end
