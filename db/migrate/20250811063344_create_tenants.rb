class CreateTenants < ActiveRecord::Migration[8.0]
  def change
    create_table :tenants do |t|
      t.string :name
      t.string :plan
      t.string :plan_changed_at
      t.string :plan_expires_at
      t.string :tax_number
      t.string :email
      t.string :locale
      t.string :time_zone

      t.timestamps
    end
  end
end
