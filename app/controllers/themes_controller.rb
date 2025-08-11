class ThemesController < ApplicationController
  before_action :set_theme, only: %i[ show edit update destroy ]

  def index
    @themes = Theme.includes(:tenant, :domains).order(created_at: :desc)
  end

  def show; end

  def new
    @theme = Theme.new
  end

  def edit; end

  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      redirect_to @theme, notice: "Theme was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @theme.update(theme_params)
      redirect_to @theme, notice: "Theme was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @theme.destroy!
    redirect_to themes_url, notice: "Theme was successfully destroyed.", status: :see_other
  end

  private
    def set_theme
      @theme = Theme.find(params.expect(:id))
    end

    def theme_params
      params.expect(theme: [:name, :html_layout, :css, :js, :tenant_id])
    end
end
