class MerciFacteursController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_before_action :verify_authenticity_token, only: :webhook
  skip_after_action :verify_authorized, only: :webhook

  def webhook
    JSON.parse(params["event"], sympbolize_names: true).each do |k, v|
      p "🟥 #{k} -> #{v}"
    end
    JSON.parse(params["detail"].first, sympbolize_names: true).each do |k, v|
      p "🟩 #{k} -> #{v}"
    end

    request.headers.each { |s| p "🟨 #{s}" }

    if request.headers['Content-Type'] == 'application/json'
      data = JSON.parse(request.body.read)

      p data
    else
      # application/x-www-form-urlencoded
      data = params.as_json
    end
  end
end
