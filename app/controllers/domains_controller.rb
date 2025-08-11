class DomainsController < ApplicationController
  before_action :set_domain, only: %i[ show edit update destroy ]

  def index
    @domains = Domain.includes(:tenant).order(created_at: :desc)
  end

  def show; end

  def new
    @domain = Domain.new
  end

  def edit; end

  def create
    @domain = Domain.new(domain_params)
    if @domain.save
      redirect_to @domain, notice: "Domain was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @domain.update(domain_params)
      redirect_to @domain, notice: "Domain was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @domain.destroy!
    redirect_to domains_url, notice: "Domain was successfully destroyed.", status: :see_other
  end

  private
    def set_domain
      @domain = Domain.find(params.expect(:id))
    end

    def domain_params
      params.expect(domain: [:host, :tenant_id])
    end
end
