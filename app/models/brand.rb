class Brand
  attr_accessor :pid,:title, :subtitle, :episodes, :year

  def initialize
    @title = nil
    @subtitle = nil
    @pid = nil
    @year = nil
    @episodes = []
  end

  def self.fetch(pid,options=nil)
    year = options[:year] if options.is_a?(Hash) && options.has_key?(:year)
    year = year || Time.now.year
    episodes = []
    url = "http://www.bbc.co.uk/programmes/#{pid}/episodes/#{year}"
    doc = Nokogiri::XML(open(url))

    brand = self.new
    brand.title = doc.search("li[@class='tleo']/a").text
    brand.subtitle = doc.search("h1/span[@class='desc']").text.gsub(/<\/?[^>]*>/, "").strip
    brand.pid = pid 
    brand.year = year 

    doc.search("dd/ol[@class='episodes']/li").each do |e| 
      episode = Episode.new
      episode.pid = e.search("div[@class='summary']/a").first['href'].split('/').last
      dt_str = "#{e.search("span[@class='date']").text} #{e.search("span[@class='starttime']").text}"
      episode.start = Time.parse(dt_str).getgm
      episode.title = e.search("span[@class='title']").text.strip
      episode.subtitle = e.search("span[@class='subtitle']").text.strip
      episode.description = e.search("div[@class='description']").text.gsub(/<\/?[^>]*>/, "").strip

      s = e.search("div[@class='location']").text.split('(').first.strip 
      next if SERVICES[s].nil? 
      episode.service = Service.new(s)
      episodes << episode 
    end

    tmp_episodes = Hash.new 
    episodes.each do |e|
      next if e.start > Time.now
      next if e.description =~ /\(R\)$/
      tmp_episodes[e.pid] = e unless e.service.nil?
    end

    tmp = tmp_episodes.values
    brand.episodes = tmp.sort_by { |e| e.start }.reverse
    brand
  end

  def image
    "http://www.bbc.co.uk/iplayer/images/progbrand/#{self.pid}_314_176.jpg"
  end

  def programmes_link
    File.join('http://bbc.co.uk/programmes', self.pid)
  end

  def guid
    Obscurer.obscure(self.pid) unless self.pid.blank?
  end
end
