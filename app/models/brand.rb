class Brand
  attr_accessor :pid,:title, :subtitle, :episodes

  def initialize
    @title = nil
    @subtitle = nil
    @pid = nil
    @episodes = []
  end

  def self.fetch(pid)
    year = Time.now.year
    episodes = []
    url = "http://www.bbc.co.uk/programmes/#{pid}/episodes/#{year}"
    doc = Nokogiri::XML(open(url))

    brand = self.new
    brand.title = doc.search("li[@class='tleo']/a").text
    brand.subtitle = doc.search("h1/span[@class='desc']").text.gsub(/<\/?[^>]*>/, "").strip
    brand.pid = pid 

    doc.search("dd/ol[@class='episodes']/li").each do |e| 
      episode = Episode.new
      episode.pid = e.search("div[@class='summary']/a").first['href'].split('/').last
      dt_str = "#{e.search("span[@class='date']").text} #{e.search("span[@class='starttime']").text}"
      episode.start = Time.parse(dt_str).getgm
      episode.title = e.search("span[@class='title']").text.strip
      episode.subtitle = e.search("span[@class='subtitle']").text.strip
      episode.description = e.search("div[@class='description']").text.gsub(/<\/?[^>]*>/, "").strip
      next if episode.description.include?('(R)')

      s = e.search("div[@class='location']").text.split('(').first.strip 
      next if SERVICES[s].nil? 
      episode.service = Service.new(s)
      episodes << episode 
    end

    brand.episodes = episodes.reverse
    brand
  end

  def image
    "http://www.bbc.co.uk/iplayer/images/progbrand/#{self.pid}_314_176.jpg"
  end

  def programmes_link
    File.join('http://bbc.co.uk/programmes', self.pid)
  end

  def rss_link 
    File.join(self.pid, 'podcasts.xml')
  end
end
