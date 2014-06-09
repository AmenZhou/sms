class SmsOutController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :send_callback
  before_action :authenticate_admin!, except: :send_callback
  def index
  end

  def msg_send
    Resque.enqueue SmsJob, params[:message_body], params[:send_number]
    flash[:notice] = "Message is sending, please check the result in message list page"
    #flash[:notice] = Phone.sms_send params[:message_body], params[:send_number]
    flash.keep
    #flash[:notice] = '正在发送...发送时间比较长，耐心等待。'#String.new
    respond_to do |format|
      format.html{ redirect_to action: :index }
      format.js
    end
    #flash[:notice] = ""
  end
  
  def message_list
    SmsOut.save_messages
    @messages = SmsOut.order('send_date desc').all
  end
  
  def send_callback
    message = SmsOut.get_message_by_sid(params[:SmsSid])
    SmsOut.create(message_id:message.sid, from:message.from, to:message.to, content:message.body, status:message.status, send_date:message.date_sent)
  end
  
  
end
