class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :to
      t.string :from
      t.integer :agent_id
      t.integer :customer_id
      t.string :text
      t.string :msg_type

      t.timestamps
    end
  end
end
