class ChangeIsBlockDefaultValueToSmsOut < ActiveRecord::Migration
  def change
  	change_column :sms_outs, :is_block, :boolean, default: false
  end
end
