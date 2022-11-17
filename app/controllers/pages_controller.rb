class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home price cgu cgv]

  def home
  end

  def price
    @packs = Pack.all.last(3)
  end

  def cgu
  end

  def cgv
  end
end
