class CreateCrawlQueries < ActiveRecord::Migration
  def change
    create_table :crawl_queries do |t|
      t.text :container_tags, array: true, default: []
      t.string :crawl_url, null: false

      t.timestamps null: false
    end
  end
end
