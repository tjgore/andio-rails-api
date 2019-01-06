class CreateConversations < ActiveRecord::Migration[5.2]
  def up
    create_table :conversations do |t|
      t.string :subject
      t.timestamps
    end
  end

  def down
    drop_table :conversations
  end
  
end
