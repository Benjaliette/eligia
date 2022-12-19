class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home price cgu cgs]

  def home
    @pinned_blogposts = Blogpost.where(pinned: true)
  end

  def price
    @packs = Pack.all.last(3)
  end

  def cgu
  end

  def cgs
    @cgs = Cgs.last
  end
end
