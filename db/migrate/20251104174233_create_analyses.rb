class CreateAnalyses < ActiveRecord::Migration[7.2]
  def change
    create_table :analyses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.references :investor, null: false, foreign_key: true
      t.text :question, null: false
      t.text :response
      t.jsonb :framework_data, default: {}
      t.integer :status, default: 0, null: false # 0: pending, 1: processing, 2: completed, 3: failed
      t.text :error_message
      t.datetime :completed_at

      t.timestamps
    end

    add_index :analyses, :status
    add_index :analyses, :completed_at
    add_index :analyses, [:user_id, :created_at]
  end
end
