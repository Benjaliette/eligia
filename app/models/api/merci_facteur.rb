# Merci facteur nous donne deux clés : une secret_key et un service_id publique
# Pour faire des requêtes à l'API on doit s'authentifier avec un accessToken
# On obtient l'access token en faisant un call à l'API avec les deux clés hashées et un timestamp
# En réponse on reçoit un accessToken valable 24h, une sorte de session, en somme
# Ce modèle stocke donc la session MerciFacteur

require 'faraday'
require 'json'

class MerciFacteur < ApplicationRecord
  def initialize
    # J'utilise 23,5h comme ça on évite les galères en cas de calls au bout de 23h59:99:99s
    if ((Time.now - MerciFacteur.last.updated_at)/3600) < 23.75
      @access_token = MerciFacteur.last.access_token
    else
      self.get_access_token
    end
  end


  private

  def get_access_token

  end
end
