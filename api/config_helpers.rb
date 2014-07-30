#Code inspire from http://codetunes.com/2014/introduction-to-building-apis-with-grape/
module API
  module Defaults
    def Defaults.included(base)
      puts "hello #{base}"
      format :json
      content_type :json, "application/json; charset=utf-8"
      default_error_formatter :json
      default_error_status 400

      # Tout erreur de validation est gérée à ce niveau
      # Va renvoyer le message d'erreur au format json
      # avec le default error status
      rescue_from :all      
    end
  end
end