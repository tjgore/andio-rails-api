class AddLatitudeAndLongitudeToRequests < ActiveRecord::Migration[5.2]
  def up
    add_column :requests, :location, :string
    add_column :requests, :latitude, :decimal
    add_column :requests, :longitude, :decimal
  end

  def down
    remove_column :requests, :location
    remove_column :requests, :latitude
    remove_column :requests, :longitude
  end
end
