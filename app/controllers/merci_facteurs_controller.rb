class MerciFacteursController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_before_action :verify_authenticity_token, only: :webhook
  skip_after_action :verify_authorized, only: :webhook

  def webhook
    p params
    p request

    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)

      p data
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end
  end
end
