class AddIsBlockToSmsOut < ActiveRecord::Migration
  def change
    add_column :sms_outs, :is_block, :boolean
  end
end
