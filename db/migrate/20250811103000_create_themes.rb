class CreateThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :themes do |t|
      t.string :name, null: false
      t.text :html_layout, null: false, default: ""
      t.text :css
      t.text :js
      t.references :tenant, foreign_key: true
      t.references :domain, foreign_key: true
      t.timestamps
    end
  end
end
