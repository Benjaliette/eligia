class MerciFacteursController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_before_action :verify_authenticity_token, only: :webhook
  skip_after_action :verify_authorized, only: :webhook

  def webhook
    webhook_event = JSON.parse(params["event"], sympbolize_names: true)
    webhook_detail = JSON.parse(params["detail"], sympbolize_names: true).first

    delivery = Delivery.find_by(envoi_id: webhook_detail[:id_envoi])
    delivery.update_state(webhook_event[:name_event])

    render status :ok
  end
end
