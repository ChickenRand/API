class Root < Grape::API
  mount UserApi
  mount QueueApi
  mount ResultsApi
  mount XpApi
end