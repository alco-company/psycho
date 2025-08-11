class ApplicationController < ActionController::Base
  before_action :set_current_tenant
  before_action :enforce_known_host!

  private
  def set_current_tenant
    Current.tenant = nil

    # Prefer subdomain slug, e.g., acme.lvh.me or acme.example.com
    sub = request.subdomains.first
    if sub.present? && sub != "www"
      Current.tenant = Tenant.find_by(slug: sub)
      return
    end

    # Optional: custom domain mapping via Domain model
    if defined?(Domain)
      Current.tenant = Domain.includes(:tenant).find_by(host: request.host)&.tenant
    end
  rescue StandardError => e
    Rails.logger.warn("set_current_tenant failed: #{e.class}: #{e.message}")
    Current.tenant = nil
  end

  def enforce_known_host!
    return if Rails.env.development? || Rails.env.test?

    # Allow bare app host for global landing and any host present in Domain table
    known = [request.host == Rails.application.config.action_mailer.default_url_options[:host]]
    known << Domain.where(host: request.host).exists? if defined?(Domain)

    # Also allow subdomain slugs of tenants under our primary domain (if configured)
    if request.subdomains.present? && request.subdomains.first != "www"
      known << Tenant.where(slug: request.subdomains.first).exists?
    end

    unless known.any?
      render file: Rails.root.join("public/404.html"), status: :not_found, layout: false
    end
  end
end
