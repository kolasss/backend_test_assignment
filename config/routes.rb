Rails.application.routes.draw do
  get 'cars/recommend', defaults: { format: :json }
end
