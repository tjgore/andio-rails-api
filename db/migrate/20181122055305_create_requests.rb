class CreateRequests < ActiveRecord::Migration[5.2]
  def up
    create_table :requests do |t|
    	t.belongs_to :user, index: true
      t.string :title
      t.text :description
      t.string :category
      t.string :status, default: 'not fullfilled'
      t.integer :start_count, default: 0
      t.integer :active, default: 1
      t.datetime :start_date

      t.timestamps
    end
  end

  def down
    drop_table :requests
  end

end
