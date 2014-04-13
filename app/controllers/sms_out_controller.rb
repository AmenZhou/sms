class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    redirect_to action: :index, notice: 'Message Send'
  end
end
