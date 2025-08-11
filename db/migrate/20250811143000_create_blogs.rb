class CreateBlogs < ActiveRecord::Migration[8.0]
  def change
    create_table :blogs do |t|
      t.references :tenant, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :comments_setting, null: false, default: 0

      t.timestamps
    end

    add_index :blogs, [ :tenant_id, :title ], unique: true
  end
end
