class CreateWebhookerSubscribers < ActiveRecord::Migration
  def change
    create_table :webhooker_subscribers do |t|
      t.string :url
      t.string :secret

      t.timestamps null: false
    end
  end
end
