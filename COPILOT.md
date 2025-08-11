# COPILOT.md

# 10/8/2025

## Multi-tenancy landing pages

Being multi-tenant, Psycho will need a way to steer a request to the proper endpoint.

### Prompt

> i am building a multi-tenant blog. how can i make it so that each tenant will have their own homepage

### Result

I wired tenant-specific homepages with subdomains and optional custom domains. Changes made:

* Data
  * Added migration to extend tenants with slug, homepage_title, homepage_body, plus unique index.
  * Added Domain model/table (host unique, belongs_to :tenant).

* Models
  * Tenant: has_many :domains, validations incl. slug format/uniqueness.
  * Domain: belongs_to :tenant, validates host uniqueness.
  * Current: holds Current.tenant.

* Controller setup
  * ApplicationController: before_action to set Current.tenant via subdomain slug, or via Domain host for custom domains.
  * Tenant::HomeController#show uses Current.tenant and renders per-tenant homepage.
  * PublicController#landing as global root (no tenant).
  * DomainsController CRUD to manage custom domains.
  * TenantsController strong params include slug/homepage fields; success notice points to lvh.me subdomain in dev.

* Routes
  * Subdomain root => tenant/home#show.
  * Custom domain root (if Domain matches) => tenant/home#show.
  * Fallback root => public#landing.
  * resources :domains added.

* Views
  * app/views/tenant/home/show for tenant homepage.
  * Public landing page.
  * Simple Domain CRUD views.

* Dev config
  * Allowed lvh.me subdomains for local testing.

### Actions

* Run database migrations.
* Create a tenant with a unique slug (e.g., “acme”).
* Visit http://acme.lvh.me:3000 to see that tenant’s homepage.
* Optionally create a Domain record (host -> tenant) and point DNS to your app; visiting that host will show the same tenant homepage.

### Prompt

> add tests for controllers, models, and the views

### Result

I added tests covering models, controllers, routing, and the tenant homepage view:

* Fixtures

  * tenants.yml: added slug and homepage fields
  * domains.yml: added two domain records

* Model tests

  * test/models/tenant_test.rb: validates presence, uniqueness, and slug format
  * test/models/domain_test.rb: validates presence and host uniqueness

* Controller tests

  * tenants_controller_test.rb: create/update include slug/homepage fields
  * domains_controller_test.rb: CRUD flow for domains
  * public_controller_test.rb: root renders landing without tenant

* Routing test

  * tenant_home_routing_test.rb: asserts subdomain and custom-domain root routes to tenant/home#show

* System test

  * tenant_home_system_test.rb: visits tenant root via lvh.me subdomain and asserts homepage content

### Actions

Run migrations, then tests:

* bin/rails db:migrate
* bin/rails test
* bin/rails test:system

### Prompt

> run tests

### Result

All tests are passing.

Ran:

* bin/rails db:migrate && bin/rails db:migrate RAILS_ENV=test
* bin/rails test

Fixes during run:

* Tightened slug validation to disallow consecutive dashes.
* Moved controller to Tenants::HomeController and updated routes.
* Added missing view at app/views/tenants/home/show.html.erb.
* Adjusted routing tests to make real requests instead of assert_routing and avoided 406s.

### Prompt

> that works but i production i cannot edit config/environments/production.rb and restart the server everywhen a user signs up and adds a domain

### Result

Use a dynamic allowlist in production:

  * Add a permissive host pattern in an initializer so you don’t need to touch production.rb:
    * host_authorization.rb
    * In production, allow DNS-like hosts via regex.

  * Enforce real allowlisting at the app layer:
    * In ApplicationController, after setting Current.tenant, check:
      * Host matches a Domain record, or
      * Subdomain matches a Tenant slug, or
      * Is your primary app host (for the global landing).
    * Otherwise render 404. No server restart needed when adding domains.

Operational flow:

  * User adds a domain in-app -> a Domain record is created.
  * Next request to that host passes HostAuthorization and is accepted by enforce_known_host!.
  * No config change or restart required.