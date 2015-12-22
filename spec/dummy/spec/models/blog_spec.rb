require 'rails_helper'

RSpec.describe Blog, type: :model do
  it 'includes Webhooker::Model' do
    expect(Blog.ancestors).to include Webhooker::Model
  end

  let(:blog) { Blog.new }

  after do
    Blog.reset_callbacks :create
    Blog.reset_callbacks :update
    Blog.reset_callbacks :destroy
    Blog.webhook_attributes = nil
    Blog.webhook_attributes_method = :as_json
  end

  describe '.webhooks' do
    it 'adds callbacks' do
      expect(Blog).to receive(:after_create).with(:_trigger_webhook_on_create)
      expect(Blog).to receive(:after_update).with(:_trigger_webhook_on_update)
      expect(Blog).to receive(:after_destroy).with(:_trigger_webhook_on_destroy)
      Blog.webhooks
    end

    it 'adds callbacks filterd by option' do
      expect(Blog).to receive(:after_update).with(:_trigger_webhook_on_update)
      expect(Blog).not_to receive(:after_create)
      expect(Blog).not_to receive(:after_destroy)
      Blog.webhooks on: [:update]
    end

    it 'sets webhook_attributes with option' do
      Blog.webhooks attributes: [:title]
      expect(Blog.webhook_attributes).to eq %w(title)
    end

    it 'sets webhook_attributes_methods with option' do
      Blog.webhooks attributes_method: :as_webhook
      expect(Blog.webhook_attributes_method).to eq :as_webhook
    end
  end

  describe '#_trigger_webhook_on_create' do
    it 'calls #_trigger_webhook' do
      expect(blog).to receive(:_trigger_webhook).with(:create)
      blog._trigger_webhook_on_create
    end
  end

  describe '#_trigger_webhook_on_update' do
    before do
      @subscriber = FactoryGirl.create(:webhooker_subscriber)
    end

    let(:blog) { FactoryGirl.create(:blog) }
    let(:new_attributes) {
      {
        title: 'New Title',
        url: 'http://new-blog.test',
        updated_at: Time.zone.now
      }
    }

    it 'calls #_trigger_webhook' do
      blog.attributes = new_attributes
      expect(blog).to receive(:_trigger_webhook).with(:update, changes: blog.changes.as_json)
      blog._trigger_webhook_on_update
    end

    describe 'with attributes filter' do
      before do
        Blog.webhooks attributes: [:title]
      end

      it 'filters changes' do
        blog.attributes = new_attributes
        expect(blog).to receive(:_trigger_webhook).with(:update, changes: blog.changes.slice(:title).as_json)
        blog._trigger_webhook_on_update
      end

      it 'skips if filtered changes is empty' do
        blog.attributes = new_attributes.slice(:url)
        expect(blog).not_to receive(:_trigger_webhook)
        blog._trigger_webhook_on_update
      end
    end
  end

  describe '#_trigger_webhook_on_destroy' do
    it 'calls #_trigger_webhook' do
      expect(blog).to receive(:_trigger_webhook).with(:destroy)
      blog._trigger_webhook_on_destroy
    end
  end

  describe '#_trigger_webhook' do
    before do
      @subscriber = FactoryGirl.create(:webhooker_subscriber)
    end

    it 'enqueues Webhooker::TriggerJob' do
      expect {
        blog._trigger_webhook :update
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      expect(job[:job]).to eq Webhooker::TriggerJob
    end

    it 'enqueues Webhooker::TriggerJob with args' do
      blog._trigger_webhook :action, a: 1, b: 2

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      args = ActiveJob::Arguments.deserialize(job[:args])
      expect(args[0]).to eq @subscriber
      expect(args[1][:resource]).to eq 'blog'
      expect(args[1][:action]).to eq 'action'
      expect(args[1][:attributes]).to eq blog.attributes.as_json
      expect(args[1][:a]).to eq 1
      expect(args[1][:b]).to eq 2
    end

    it 'sets attributes with custom attributes_method' do
      Blog.webhook_attributes_method = :as_webhook
      blog._trigger_webhook :action

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      args = ActiveJob::Arguments.deserialize(job[:args])
      expect(args[1][:attributes]).to eq blog.attributes.as_json.merge('as_webhook' => true)
    end
  end
end
