# db/migrate/20250811_update_theme_associations.rb
class UpdateThemeAssociations < ActiveRecord::Migration[8.0]
  def up
    # 1) Add columns (nullable first to allow backfills)
    add_reference :domains, :theme, foreign_key: { to_table: :themes, on_delete: :nullify }
    add_reference :tenants, :default_theme, foreign_key: { to_table: :themes, on_delete: :nullify }

    # 2) Backfill themes.tenant_id BEFORE making it NOT NULL
    # If you truly require every theme to have an owner, decide a policy:
    # - delete orphans, or
    # - attach to a fallback tenant, or
    # - raise and fix manually
    orphan_themes = execute(<<~SQL).to_a # returns array of hashes in PG; adapt if needed
      SELECT id FROM themes WHERE tenant_id IS NULL
    SQL

    if orphan_themes.any?
      # Example policy: attach to the first tenant (or a seeded "system" tenant)
      fallback_tenant_id = select_value("SELECT id FROM tenants ORDER BY id LIMIT 1")
      raise "No tenants to attach orphan themes" unless fallback_tenant_id

      ids = orphan_themes.map { |r| r["id"] || r[:id] }
      execute <<~SQL
        UPDATE themes SET tenant_id = #{fallback_tenant_id} WHERE id IN (#{ids.join(",")})
      SQL
    end

    # 3) Now enforce NOT NULL on themes.tenant_id
    change_column_null :themes, :tenant_id, false

    # 4) If themes used to belong_to :domain, drop that (after we added domains.theme_id)
    if column_exists?(:themes, :domain_id)
      remove_foreign_key :themes, :domains rescue nil
      remove_reference :themes, :domain, foreign_key: true
    end

    # (Optional) add useful indexes if not auto-created
    add_index :tenants, :default_theme_id unless index_exists?(:tenants, :default_theme_id)
    add_index :domains, :theme_id unless index_exists?(:domains, :theme_id)
  end

  def down
    # Reverse indexes
    remove_index :tenants, :default_theme_id if index_exists?(:tenants, :default_theme_id)
    remove_index :domains, :theme_id if index_exists?(:domains, :theme_id)

    # Restore themes.domain if needed (schema may not need this)
    # add_reference :themes, :domain, foreign_key: true unless column_exists?(:themes, :domain_id)

    # Revert NOT NULL
    change_column_null :themes, :tenant_id, true

    # Remove the new FKs/columns
    remove_reference :tenants, :default_theme, foreign_key: true if column_exists?(:tenants, :default_theme_id)
    remove_reference :domains, :theme, foreign_key: true if column_exists?(:domains, :theme_id)
  end
end
