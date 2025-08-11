class PublicController < ApplicationController
  skip_before_action :set_current_tenant

  def landing
  end
end
