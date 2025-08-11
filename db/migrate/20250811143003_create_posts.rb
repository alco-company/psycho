class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :blog, null: false, foreign_key: true
      t.string :title
      t.datetime :published_at

      t.timestamps
    end
  end
end
