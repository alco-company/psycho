# Dynamic host authorization for production to support custom tenant domains without restarts.
# We allow any valid hostname (container name, domain) optionally with a port and enforce
# actual domain/tenant allow-listing in ApplicationController.

if Rails.env.production?
  # Replace any existing host entries with a permissive DNS/container name + optional :port pattern.
  Rails.application.config.hosts.clear
  Rails.application.config.hosts << /\A[a-z0-9.-]+(:\d+)?\z/
end
