class MerciFacteursController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_before_action :verify_authenticity_token, only: :webhook
  skip_after_action :verify_authorized, only: :webhook

  def webhook
    webhook_event = JSON.parse(params["event"], symbolize_names: true)
    webhook_detail = JSON.parse(params["detail"], symbolize_names: true).first

    delivery = Delivery.find_by(envoi_id: webhook_detail[:id_envoi])
    delivery.update_delivery_state(webhook_event[:name_event])

    render json: {}, status: 200
  end
end
