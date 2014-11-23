class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.integer :quantity

      t.timestamps
    end

    add_reference :cart_items, :cart, :index => true
    add_reference :cart_items, :product, :index => true
  end
end
