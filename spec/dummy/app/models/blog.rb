class Blog < ActiveRecord::Base
  def as_webhook
    as_json.merge(as_webhook: true)
  end
end
