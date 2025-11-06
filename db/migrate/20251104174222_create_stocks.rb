class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :ticker, null: false
      t.string :name
      t.jsonb :cached_data, default: {}
      t.datetime :data_fetched_at

      t.timestamps
    end

    add_index :stocks, :ticker, unique: true
  end
end
