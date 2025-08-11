class AddTailwindAssetToTenants < ActiveRecord::Migration[8.0]
  def change
    add_column :tenants, :tailwind_digest, :string
    add_column :tenants, :tailwind_input_digest, :string
    add_column :tenants, :tailwind_built_at, :datetime
  end
end
