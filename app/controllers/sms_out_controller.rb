class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    Phone.send_msg params[:message_body], params[:send_number]
    flash[:notice] = 'Message Send 2'
    flash.keep
    redirect_to action: :index
  end
end
