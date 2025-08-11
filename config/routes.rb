Rails.application.routes.draw do
  resources :posts
  resources :tenants
  resources :domains
  resources :themes
  resources :blogs
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Tenant subdomain root (only when subdomain slug matches an existing tenant)
  constraints(lambda { |req|
    req.subdomains.present? && req.subdomains.first != "www" && defined?(Tenant) && Tenant.where(slug: req.subdomains.first).exists?
  }) do
    root to: "tenants/home#show", as: :tenant_root
  end

  # Custom domain root mapped via Domain model
  constraints(lambda { |req| defined?(Domain) && Domain.where(host: req.host).exists? }) do
    root to: "tenants/home#show", as: :custom_domain_root
  end

  # Tenant blog landing routes for tenant-aware hosts (subdomain or custom domain)
  constraints(lambda { |req|
    (req.subdomains.present? && req.subdomains.first != "www" && defined?(Tenant) && Tenant.where(slug: req.subdomains.first).exists?) ||
    (defined?(Domain) && Domain.where(host: req.host).exists?)
  }) do
    scope module: "tenants", as: "tenant" do
      get "blog", to: "blogs#default", as: :blog
      get "blog/:id", to: "blogs#show", as: :blog_by_id
    end
  end

  # Fallback for non-tenant hosts to avoid RoutingError
  get "blog", to: "public#landing"
  get "blog/:id", to: "public#landing"

  # Global landing page root (no tenant)
  root to: "public#landing"
end
