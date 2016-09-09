class CreateCrawlQueryResults < ActiveRecord::Migration
  def change
    create_table :crawl_query_results do |t|
      t.string :container_tag, null: false
      t.text :content
      t.integer :crawl_query_id, null: false

      t.timestamps null: false
    end
  end
end
