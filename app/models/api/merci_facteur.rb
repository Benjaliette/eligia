# Merci facteur nous donne deux clés : une secret_key et un service_id publique
# Pour faire des requêtes à l'API on doit s'authentifier avec un accessToken
# On obtient l'access token en faisant un call à l'API avec les deux clés hashées et un timestamp
# En réponse on reçoit un accessToken valable 24h, une sorte de session, en somme
# Ce modèle stocke donc la session MerciFacteur

require 'faraday'
require 'json'

class MerciFacteur < ApplicationRecord
  after_create :query_access_token

  def self.open_session
    # Si il y a une instance de MerciFacteur avec un access_token valable, on la récupère.
    # Sinon on en crée une autre
    unless MerciFacteur.count.zero? || MerciFacteur.last.access_token.nil? || MerciFacteur.last.expire_at.nil?
      return MerciFacteur.last if (MerciFacteur.last.expire_at > (Time.now.to_i + 1800))
    end

    return MerciFacteur.create
  end

  private

  def query_access_token
    the_timestamp = Time.now.to_i.to_s
    # the .to_i creates the timestamp in the right format (ex: 1668510062) and the to_s converts it into string to be used in the hashing method

    service_id = ENV.fetch('MERCI_FACTEUR_SERVICE_ID')
    secret_key = ENV.fetch('MERCI_FACTEUR_SECRET_KEY')
    hashed_key = hash_the_key(the_timestamp, service_id, secret_key)
    p "🛑"
    p request.ip
    p request.remote_ip
    p Socket.ip_address_list.detect(&:ipv4_private?).try(:ip_address)
    p "✅"
    response = Faraday.new(
      url: 'https://www.merci-facteur.com/api/1.2/prod/service/getToken',
      headers: { 'ww-service-signature': hashed_key, 'ww-timestamp': the_timestamp, 'ww-service-id': service_id, 'ww-authorized-ip': "#{request.remote_ip};82.210.42.78" }
    ).post
    response = JSON.parse(response.body, symbolize_names: true)

    self.update(
      access_token: response[:token],
      expire_at: response[:expire].to_i
    )
  end

  def hash_the_key(timestamp, service_id, secret_key)
    data = service_id + timestamp
    return OpenSSL::HMAC.hexdigest("SHA256", secret_key, data)
  end
end
