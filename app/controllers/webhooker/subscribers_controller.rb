require_dependency "webhooker/application_controller"

module Webhooker
  class SubscribersController < ApplicationController
    before_action :set_subscriber, only: [:destroy]

    # GET /subscribers
    def index
      @subscribers = Subscriber.page(params[:page])
    end

    # POST /subscribers
    def create
      @subscriber = Subscriber.new(subscriber_params)

      if @subscriber.save
        redirect_to subscribers_url, notice: 'Successed to create.'
      else
        redirect_to subscribers_url, alert: 'Failed to create.'
      end
    end

    # DELETE /subscribers/1
    def destroy
      @subscriber.destroy
      redirect_to subscribers_url, notice: 'Successed to destroy.'
    end

    private

    def set_subscriber
      @subscriber = Subscriber.find(params[:id])
    end

    def subscriber_params
      params.require(:subscriber).permit(:url, :secret)
    end
  end
end
