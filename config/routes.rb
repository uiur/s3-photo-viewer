Rails.application.routes.draw do
  get ':bucket/*prefix', to: 'images#index', format: false, bucket: /[^\/]+/, as: :images
end
