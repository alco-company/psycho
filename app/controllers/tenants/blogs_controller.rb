module Tenants
  class BlogsController < ApplicationController
    before_action :ensure_tenant!

    def default
      @blogs = Current.tenant.blogs.includes(:posts).order(created_at: :desc)
      render :index
    end

    def show
      @blog = Current.tenant.blogs.find(params[:id])
    end

    private

    def ensure_tenant!
      @tenant = Current.tenant
      redirect_to root_path, alert: "Tenant not found" unless @tenant
    end
  end
end
