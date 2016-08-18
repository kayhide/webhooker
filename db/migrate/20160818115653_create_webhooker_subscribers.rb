class CreateWebhookerSubscribers < ActiveRecord::Migration[5.0]
  def change
    create_table :webhooker_subscribers do |t|
      t.string :url
      t.string :secret

      t.timestamps
    end
  end
end
