class CreateConversationsRequests < ActiveRecord::Migration[5.2]
  def up
    create_table :conversations_requests do |t|
      t.belongs_to :conversation, index: true
      t.belongs_to :request, index: true
      #t.belongs_to :started_by, index: true, foreign_key: {to_table: :users}
      t.timestamps
    end
  end

  def down
    drop_table :conversations_requests
  end

end
