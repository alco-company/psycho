class AddMultitenancyFields < ActiveRecord::Migration[8.0]
  def change
    change_table :tenants, bulk: true do |t|
      t.string :slug, null: false
      t.string :homepage_title
      t.text :homepage_body
      t.index :slug, unique: true
    end

    create_table :domains do |t|
      t.string :host, null: false
      t.references :tenant, null: false, foreign_key: true
      t.timestamps
    end

    add_index :domains, :host, unique: true
  end
end
