class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    #Resque.enqueue SmsJob, params[:message_body], params[:send_number]
    flash[:notice] = ""
    notice_arr = Phone.sms_send params[:message_body], params[:send_number]
    #flash[:notice] = '正在发送...发送时间比较长，耐心等待。'#String.new
    notice_arr.each do |notice|
      flash[:notice] << "Send message to #{notice[:to]}, message content is: #{notice[:body]}.||  "
    end
    flash.keep
    respond_to do |format|
      format.html{ redirect_to action: :index }
      format.js
    end
  end
  
  def message_list
    @messages = Phone.get_messages
  end
end
