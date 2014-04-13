class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    Phone.send_msg params[:message_body], params[:send_number]
    redirect_to action: :index, notice: 'Message Send'
  end
end
