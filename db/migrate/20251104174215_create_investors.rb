class CreateInvestors < ActiveRecord::Migration[7.2]
  def change
    create_table :investors do |t|
      t.string :name, null: false
      t.integer :persona, null: false
      t.text :system_prompt, null: false
      t.jsonb :framework_config, default: {}
      t.string :avatar_url
      t.boolean :active, default: true, null: false
      t.integer :analyses_count, default: 0, null: false

      t.timestamps
    end

    add_index :investors, :persona
    add_index :investors, :active
  end
end
