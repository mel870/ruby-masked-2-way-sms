class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :bw_phone_number
      t.string :agent_phone_number

      t.timestamps
    end
  end
end
