class CreateSmsOuts < ActiveRecord::Migration
  def change
    create_table :sms_outs do |t|
      t.string :from
      t.string :to
      t.text :content
      t.date :send_date
      t.string :status

      t.timestamps
    end
  end
end
