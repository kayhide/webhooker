require 'rails_helper'

module Webhooker
  RSpec.describe SubscribersController, type: :controller do
    describe "GET #index" do
      it "assigns all subscribers as @subscribers" do
        subscriber = FactoryGirl.create(:webhooker_subscriber)
        get :index
        expect(assigns(:subscribers)).to eq([subscriber])
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:valid_attributes) {
          {
            url: 'http://webhooker.test/subscribe',
            secret: '9821c09e'
          }
        }

        it "creates a new Subscriber" do
          expect {
            post :create, {:subscriber => valid_attributes}
          }.to change(Subscriber, :count).by(1)
        end

        it "assigns a newly created subscriber as @subscriber" do
          post :create, {:subscriber => valid_attributes}
          expect(assigns(:subscriber)).to be_a(Subscriber)
          expect(assigns(:subscriber)).to be_persisted
        end

        it "redirects to the subscribers list" do
          post :create, {:subscriber => valid_attributes}
          expect(response).to redirect_to(subscribers_url)
        end
      end

      context "with invalid params" do
        let(:invalid_attributes) {
          {
            url: nil,
            secret: nil
          }
        }

        it "redirects to the subscribers list" do
          post :create, {:subscriber => invalid_attributes}
          expect(response).to redirect_to(subscribers_url)
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested subscriber" do
        subscriber = FactoryGirl.create(:webhooker_subscriber)
        expect {
          delete :destroy, {:id => subscriber.to_param}
        }.to change(Subscriber, :count).by(-1)
      end

      it "redirects to the subscribers list" do
        subscriber = FactoryGirl.create(:webhooker_subscriber)
        delete :destroy, {:id => subscriber.to_param}
        expect(response).to redirect_to(subscribers_url)
      end
    end
  end
end
