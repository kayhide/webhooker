require 'rails_helper'

module Webhooker
  RSpec.describe Model do
    it 'is included into ActiveRecord::Base' do
      expect(ActiveRecord::Base.ancestors).to include Webhooker::Model
    end
  end
end
