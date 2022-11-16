# Merci facteur nous donne deux clés : une secret_key et un service_id publique
# Pour faire des requêtes à l'API on doit s'authentifier avec un accessToken
# On obtient l'access token en faisant un call à l'API avec les deux clés hashées et un timestamp
# En réponse on reçoit un accessToken valable 24h, une sorte de session, en somme
# Ce modèle stocke donc la session MerciFacteur

require 'faraday'
require 'json'
require 'dotenv'

class MerciFacteur < ApplicationRecord
  after_create :set_access_token

  def self.open_session
    # Si il y a une instance de MerciFacteur avec un access_token valable, on la récupère.
    # Sinon on en crée une autre
    unless MerciFacteur.count.zero? || MerciFacteur.last.access_token.nil?
      return MerciFacteur.last if ((Time.now - MerciFacteur.last.updated_at) / 3600) < 23.75
    end

    return MerciFacteur.create
  end

  private

  def set_access_token
    # J'utilise 23,5h comme ça on évite les galères en cas de calls au bout de 23h59:99:99s
    unless MerciFacteur.count.zero? || MerciFacteur.last.access_token.nil?
      access_token = MerciFacteur.last.access_token if ((Time.now - MerciFacteur.last.updated_at) / 3600) < 23.75
      self.update(access_token: access_token)
    end

    self.update(access_token: querry_access_token)
  end

  def querry_access_token
    the_timestamp = Time.now.to_i.to_s
    # the .to_i creates the timestamp in the right format (ex: 1668510062) and the to_s converts it into string to be used in the hashing method

    service_id = ENV.fetch('MERCI_FACTEUR_SERVICE_ID')
    secret_key = ENV.fetch('MERCI_FACTEUR_SECRET_KEY')
    hashed_key = hash_the_key(the_timestamp, service_id, secret_key)

    response = Faraday.new(
      url: 'https://www.merci-facteur.com/api/1.2/prod/service/getToken',
      headers: { 'ww-service-signature': hashed_key, 'ww-timestamp': the_timestamp, 'ww-service-id': service_id, 'ww-authorized-ip': "#{Socket.ip_address_list.detect(&:ipv4_private?).try(:ip_address)};82.210.42.78" }
    ).post
    response = JSON.parse(response.body, symbolize_names: true)

    return response[:token]
  end

  def hash_the_key(timestamp, service_id, secret_key)
    data = service_id + timestamp
    return OpenSSL::HMAC.hexdigest("SHA256", secret_key, data)
  end
end