module Webhooker
  class TriggerJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      # Do something later
    end
  end
end
