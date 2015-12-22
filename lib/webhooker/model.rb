require 'active_support/concern'
require 'active_support/lazy_load_hooks'

module Webhooker
  module Model
    extend ActiveSupport::Concern

    def _trigger_webhook_on_create
      _trigger_webhook :create
    end

    def _trigger_webhook_on_update
      filtered_changes =
        if self.class.webhook_attributes
          changes.slice(*self.class.webhook_attributes)
        else
          changes
        end
      if filtered_changes.present?
        _trigger_webhook :update, changes: filtered_changes.as_json
      end
    end

    def _trigger_webhook_on_destroy
      _trigger_webhook :destroy
    end

    def _trigger_webhook action, data = {}
      data = {
        resource: model_name.singular,
        action: action.to_s,
        attributes: send(*self.class.webhook_attributes_method).as_json,
      }.merge(data)
      Subscriber.find_each do |subscriber|
        TriggerJob.perform_later subscriber, data
      end
    end

    module ClassMethods
      attr_accessor :webhook_attributes, :webhook_attributes_method

      def webhooks *args
        options = args.extract_options!
        (options[:on] || %i(create update destroy)).each do |action|
          send :"after_#{action}", :"_trigger_webhook_on_#{action}"
        end
        @webhook_attributes = options[:attributes].try(:map, &:to_s)
        @webhook_attributes_method = options[:attributes_method] || Webhooker.config.attributes_method
      end
    end
  end
end

ActiveSupport.on_load :active_record do |base|
  base.include Webhooker::Model
end
