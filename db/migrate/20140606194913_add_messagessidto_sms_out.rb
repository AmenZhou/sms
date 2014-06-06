class AddMessagessidtoSmsOut < ActiveRecord::Migration
  def change
    add_column :sms_outs, :message_id, :string 
  end
end
