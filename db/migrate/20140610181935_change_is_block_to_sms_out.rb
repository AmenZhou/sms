class ChangeIsBlockToSmsOut < ActiveRecord::Migration
  def change
  	change_column_default :sms_outs, :is_block, default: true
  end
end
