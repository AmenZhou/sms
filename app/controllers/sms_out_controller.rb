class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    #Resque.enqueue SmsJob, params[:message_body], params[:send_number]
    flash[:notice] = ""
    flash[:notice] = Phone.sms_send params[:message_body], params[:send_number]
    flash.keep
    #flash[:notice] = '正在发送...发送时间比较长，耐心等待。'#String.new
    respond_to do |format|
      format.html{ redirect_to action: :index }
      format.js
    end
    flash[:notice] = ""
  end
  
  def message_list
    @messages = Phone.get_messages
  end
end
