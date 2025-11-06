class CreatePortfolios < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolios do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :stock_tickers, default: []

      t.timestamps
    end

    add_index :portfolios, [:user_id, :name], unique: true
  end
end
