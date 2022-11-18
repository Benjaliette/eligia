class MerciFacteursController < ApplicationController
  skip_before_action :authenticate_user!, only: :webhook
  skip_before_action :verify_authenticity_token, only: :webhook
  skip_after_action :verify_authorized, only: :webhook

  def webhook
    webhook_event = JSON.parse(params["event"], symbolize_names: true)

    deliveries = []

    JSON.parse(params["detail"], symbolize_names: true).map do |detail|
      delivery = Delivery.find_by(envoi_id: detail[:id_envoi])
      deliveries << delivery unless delivery.nil?
    end

    deliveries.each { |delivery| delivery.update_delivery_state(webhook_event[:name_event]) }

    render json: {}, status: 200
  end
end
