require 'rails_helper'

RSpec.describe Blog, type: :model do
  it 'includes Webhooker::Model' do
    expect(Blog.ancestors).to include Webhooker::Model
  end

  after do
    Blog.reset_callbacks :save
    Blog.webhook_attributes = nil
  end

  describe '.webhooks' do
    it 'adds after_save callback' do
      expect {
        Blog.webhooks
      }.to change { Blog._save_callbacks.count }.by(1)
    end

    it 'sets webhook_attributes with option' do
      Blog.webhooks attributes: [:title]
      expect(Blog.webhook_attributes).to eq %w(title)
    end
  end

  describe '#_trigger_webhook' do
    before do
      @subscriber = FactoryGirl.create(:webhooker_subscriber)
      @blog = Blog.new
    end

    let(:new_attributes) { { title: 'New Title', url: 'http://new-blog.test' } }

    it 'enqueues Webhooker::TriggerJob' do
      @blog.attributes = new_attributes
      expect {
        @blog._trigger_webhook
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      expect(job[:job]).to eq Webhooker::TriggerJob
    end

    it 'enqueues Webhooker::TriggerJob with args' do
      @blog.attributes = new_attributes
      @blog._trigger_webhook

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      args = ActiveJob::Arguments.deserialize(job[:args])
      expect(args[0]).to eq @subscriber
      expect(args[1][:type]).to eq @blog.class.name
      expect(args[1][:attributes]).to eq @blog.attributes.as_json
      expect(args[1][:changes]).to eq @blog.changes.as_json
    end

    describe 'with attributes filter' do
      before do
        Blog.webhooks attributes: [:title]
      end

      it 'filters changes' do
        @blog.attributes = new_attributes
        @blog._trigger_webhook

        job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
        args = ActiveJob::Arguments.deserialize(job[:args])
        expect(args[1][:changes].keys).to eq ['title']
      end

      it 'skips if filtered changes is empty' do
        @blog.attributes = new_attributes.slice(:url)
        expect {
          @blog._trigger_webhook
        }.not_to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count)
      end
    end
  end
end
