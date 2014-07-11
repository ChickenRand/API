class QueueApi < Grape::API
  helpers LoginHelpers
  prefix "queue"
  format :json
  content_type :json, "application/json; charset=utf-8"
  default_error_formatter :json
  default_error_status 400

  # Tout erreur de validation est gérée à ce niveau
  # Va renvoyer le message d'erreur au format json
  # avec le default error status
  rescue_from :all

  desc "return the current queue state"
  get '/state' do
    {estimated_time: 0, length: 0}
  end

  desc "add a user to the queue with a specific xp"
  params do
    requires :xp_id, type: Integer
  end
  post do
    authenticate!
  end
end