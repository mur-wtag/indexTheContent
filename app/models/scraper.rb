class Scraper
  attr_reader :url, :tags

  def self.call(url, tags)
    new(url, tags).call
  end

  def initialize(url, tags)
    @url = url
    @tags = [tags].flatten.uniq
  end

  def call
    uri = URI.parse url
    crawl_base_url = "#{uri.scheme}://#{uri.host}"
    path = uri.path
    crawl_tags = tags

    Wombat.crawl do
      base_url crawl_base_url
      path path

      crawl_tags.each do |cc|
        public_send(cc, {xpath: "//#{cc}"}, :list)
      end
    end
  end
end
