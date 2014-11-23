class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.timestamps
    end

    add_reference :carts, :user, :index => true
  end
end
