class CreateCars < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.string :address
      t.string :brand
      t.string :category
      t.string :model
      t.integer :price_per_hour
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
