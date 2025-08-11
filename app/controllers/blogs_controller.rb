class BlogsController < ApplicationController
  before_action :set_blog, only: %i[ show edit update destroy ]

  def index
    @blogs = Blog.includes(:tenant).order(created_at: :desc)
  end

  def show; end

  def new
    @blog = Blog.new
  end

  def edit; end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      redirect_to @blog, notice: "Blog was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: "Blog was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy!
    redirect_to blogs_url, notice: "Blog was successfully destroyed.", status: :see_other
  end

  private
    def set_blog
      @blog = Blog.find(params.expect(:id))
    end

    def blog_params
      params.expect(blog: [ :tenant_id, :title, :description, :comments_setting ])
    end
end
