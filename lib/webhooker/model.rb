require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module Webhooker
  module Model
    extend ActiveSupport::Concern

    def _trigger_webhook
      attrs = attributes
      if self.class.webhook_attributes
        attrs = attrs.slice(*self.class.webhook_attributes)
      end

      if (changes.keys & attrs.keys).present?
        data = {
          type: self.class.name,
          attributes: attributes.as_json,
          changes: changes.slice(*attrs.keys).as_json,
        }
        Subscriber.find_each do |subscriber|
          TriggerJob.perform_later subscriber, data
        end
      end
    end

    module ClassMethods
      attr_accessor :webhook_attributes

      def webhooks *args
        after_save :_trigger_webhook
        options = args.extract_options!
        @webhook_attributes = options[:attributes].try(:map, &:to_s)
      end
    end
  end
end

ActiveSupport.on_load :active_record do |base|
  base.include Webhooker::Model
end
