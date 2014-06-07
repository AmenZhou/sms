class ChangeColumnSendDatetosmsOuts < ActiveRecord::Migration
  def change
    change_column :sms_outs, :send_date, :datetime
  end
end
