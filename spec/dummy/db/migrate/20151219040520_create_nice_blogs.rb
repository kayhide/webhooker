class CreateNiceBlogs < ActiveRecord::Migration
  def change
    create_table :nice_blogs do |t|
      t.string :title
      t.string :url

      t.timestamps null: false
    end
  end
end
