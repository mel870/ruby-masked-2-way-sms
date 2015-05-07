class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :agent_id
      t.string :phone_number

      t.timestamps
    end
  end
end
