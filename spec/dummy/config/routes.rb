Rails.application.routes.draw do

  mount Webhooker::Engine => "/webhooker"
end
