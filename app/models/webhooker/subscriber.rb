module Webhooker
  class Subscriber < ActiveRecord::Base
    validates :url, presence: true
    validates :secret, presence: true
  end
end
