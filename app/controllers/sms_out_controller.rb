class SmsOutController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:send_callback]
  before_action :authenticate_admin!, except: [:send_callback]
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  
  def index
  end

  def edit
  end
  
  def new
  end
  
  def create
  end
  
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end
  
  def show
  end
  
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to message_list_url }
    end
  end
  
  def respond_checkbox
    @message = SmsOut.find(params[:message_id])
    if @message
      @message.is_block =  !@message.is_block
      @message.save
      render text: "#{@message.from} 黑名单状态改变!"
    end
  end
  
  def msg_send
    numbers = SmsOut.number_filter(params[:send_number])
    Resque.enqueue SmsJob, params[:message_body], numbers
    flash[:notice] = "Message is sending, please check the result in message list page"
    #flash[:notice] = Phone.sms_send params[:message_body], params[:send_number]
    flash.keep
    respond_to do |format|
      format.html{ redirect_to action: :index }
      format.js
    end
  end
  
  def message_list
    SmsOut.save_messages
    @messages = SmsOut.order('send_date desc').page(params[:page])
  end
  
  def send_callback
    message = SmsOut.get_message_by_sid(params[:SmsSid])
    SmsOut.create(message_id:message.sid, from:message.from, to:message.to, content:message.body, status:message.status, send_date:message.date_sent)
  end
  
 private
    # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = SmsOut.find(params[:id])
  end
  
  def message_params
    params.require(:sms_out).permit(:message_id, :from, :to, :content, :send_date, :status, :is_block)
  end
end
