require 'rails_helper'

RSpec.describe Nice::Blog, type: :model do
  it 'includes Webhooker::Model' do
    expect(Nice::Blog.ancestors).to include Webhooker::Model
  end

  let(:blog) { Nice::Blog.new }

  after do
    Blog.reset_callbacks :create
    Blog.reset_callbacks :update
    Blog.reset_callbacks :destroy
    Blog.webhook_attributes = nil
  end

  describe '#_trigger_webhook' do
    before do
      @subscriber = FactoryGirl.create(:webhooker_subscriber)
    end

    it 'enqueues Webhooker::TriggerJob with args' do
      blog._trigger_webhook :action, a: 1, b: 2

      job = ActiveJob::Base.queue_adapter.enqueued_jobs.last
      args = ActiveJob::Arguments.deserialize(job[:args])
      expect(args[0]).to eq @subscriber
      expect(args[1][:resource]).to eq 'nice_blog'
      expect(args[1][:action]).to eq 'action'
      expect(args[1][:attributes]).to eq blog.attributes.as_json
      expect(args[1][:a]).to eq 1
      expect(args[1][:b]).to eq 2
    end
  end
end
