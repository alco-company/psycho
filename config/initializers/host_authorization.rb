# Dynamic host authorization for production to support custom tenant domains without restarts.
# We allow any valid hostname at the Rack HostAuthorization layer and enforce
# actual domain/tenant allow-listing in ApplicationController.

if Rails.env.production?
  # Accept DNS-like hosts. Do not include ports here; Host header excludes the port.
  Rails.application.config.hosts << /\A[a-z0-9.-]+\z/
end
