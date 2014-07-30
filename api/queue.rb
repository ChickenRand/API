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
    Queue::get_state()
  end

  desc "add a user to the queue with a specific xp"
  params do
    requires :xp_id, type: Integer
  end
  post do
    authenticate!
    Queue::add_to_queue(params[:xp_id])
  end

  desc "Used to tell the server we are still waiting. If not called every 30s the queue item is automatically remove."
  get ':id' do
    authenticate!
    Queue::update_queue_item(params[:id])
  end

  delete ':id' do
    authenticate!
    Queue::remove_from_queue(params[:id])
  end

  desc "Tell the server that we start the experiment."
  post ':id/start' do
    authenticate!
    item = Queue::start_experiment(params[:id])
    error!('Item not on top') if item.nil?
    Rng.first
  end
end