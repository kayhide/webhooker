module Webhooker
  class Subscriber < ApplicationRecord
    validates :url, presence: true
    validates :secret, presence: true
  end
end
