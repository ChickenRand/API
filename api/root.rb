class Root < Grape::API
  format :json

  mount UserApi
  mount QueueApi
  mount ResultsApi
  mount XpApi
end