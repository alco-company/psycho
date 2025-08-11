class UpdateThemeAssociations < ActiveRecord::Migration[8.0]
  def change
    # Domains choose a theme; themes no longer belong to domains
    add_reference :domains, :theme, foreign_key: true

    # Tenants can select a default theme
    add_reference :tenants, :default_theme, foreign_key: { to_table: :themes }

    # Remove old domain_id on themes if it exists
    if column_exists?(:themes, :domain_id)
      remove_reference :themes, :domain, foreign_key: true
    end

    # Ensure themes have a tenant owner
    change_column_null :themes, :tenant_id, false
  end
end
