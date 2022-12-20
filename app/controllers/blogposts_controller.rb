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
    @blogpost.user = current_user

    if @blogpost.save
      redirect_to blogpost_path(@blogpost)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @blogpost.update(blogpost_params)
      redirect_to blogpost_path(@blogpost)
    else
      render :new
    end
  end

  def destroy
    @blogpost.destroy

    redirect_to blogposts_path, status: :see_other
  end

  private

  def set_blogpost
    @blogpost = Blogpost.friendly.find(params[:id])
  end

  def autorize_blogpost
    authorize @blogpost
  end

  def blogpost_params
    params.require(:blogpost).permit(:title, :body, :main_picture, :pinned)
  end
end


##
