json.extract! tenant, :id, :name, :plan, :plan_changed_at, :plan_expires_at, :tax_number, :email, :locale, :time_zone, :created_at, :updated_at
json.url tenant_url(tenant, format: :json)
