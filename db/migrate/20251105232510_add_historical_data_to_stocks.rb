class AddHistoricalDataToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :historical_data, :jsonb
  end
end
