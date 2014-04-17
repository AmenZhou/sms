class SmsOutController < ApplicationController
  def index
  end

  def msg_send
    Resque.enqueue SmsJob, params[:message_body], params[:send_number]
    flash[:notice] = 'processing'#String.new
    #notice_arr.each do |notice|
      #flash[:notice] << "Send message to #{notice[:to]}, message content is: #{notice[:body]}.||  "
    #end
    flash.keep
    redirect_to action: :index
  end
end
