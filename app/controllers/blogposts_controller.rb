class BlogpostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_blogpost, only: %i[show edit update destroy]
  after_action :autorize_blogpost, only: %i[show new create edit update destroy]

  def index
    @blogposts = policy_scope(Blogpost)
  end

  def show
  end

  def new
    @blogpost = Blogpost.new
  end

  def create
    @blogpost = Blogpost.new(blogpost_params)

    if @blogpost.save
      redirect_to blogpost_path(@blogpost)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_blogpost
    @blogpost = Blogpost.find(params[:id])
  end

  def autorize_blogpost
    authorize @blogpost
  end

  def blogpost_params
    params.require(:blogpost).permit(:title, :body)
  end
end
