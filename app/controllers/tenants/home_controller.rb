module Tenants
  class HomeController < ApplicationController
    def show
      @tenant = Current.tenant
      redirect_to root_path, alert: "Tenant not found" and return unless @tenant
    end
  end
end
