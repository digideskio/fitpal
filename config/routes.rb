Rails.application.routes.draw do
  root to: 'macros#index'
  get '/calculate_tdee', as: :calculate_tdee, to: 'macros#calculate_tdee'
  get '/pull_weight', as: :pull_weight, to: 'macros#pull_weight'
  get '/set_training_day_macros', as: :set_training_day_macros, to: 'macros#set_training_day_macros'
  get '/set_rest_day_macros', as: :set_rest_day_macros, to: 'macros#set_rest_day_macros'
end
