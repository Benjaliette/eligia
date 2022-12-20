class HelpsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index contrats documents recapitulatif tarifs]

  def index
  end

  def contrats
  end

  def documents
  end

  def recapitulatif
  end

  def tarifs
    @packs = Pack.all.last(3)
  end
end
