class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.float  :price, null: false
      t.float  :quantity, null: false
      t.string :measurement
      t.text   :description

      t.timestamps null: false
    end
  end
end
