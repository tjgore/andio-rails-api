class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :conversation, index: true, foreign_key: true
      t.references :from, index: true, foreign_key: {to_table: :users}
      t.references :to, index: true, foreign_key: {to_table: :users}
      t.text :body, null: false 
      t.integer :read, default: 0, null: false

      t.timestamps
    end
  end
end
