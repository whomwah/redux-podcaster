require 'net/http'

class Redux 
  def self.valid_user?(u,p)
    res = Net::HTTP.post_form(URI.parse("#{REDUX_URL}/user"), {
      'username' => u, 
      'password' => p, 
      'dologin' => 1
    })
    doc = Nokogiri::XML(res.body)
    valid = doc.search("body/div/a").text.strip =~ /Logged in!/
    !valid.nil?
  end

  def self.data(pid)
    return unless brand = Brand.fetch(pid)
    episodes_to_use = []

    brand.episodes.each do |e|
      next if episodes_to_use.size >= MAX_EPISODES

      url = File.join(e.redux_url)
      e.redux_link = url
      puts e.redux_link + ' ' + e.pid
      res = Net::HTTP.post_form(URI.parse(url), CREDENTIALS)
      doc = Nokogiri::XML(res.body)
      results=[]

      doc.search("a").each do |el|
        str = el["href"]
        filter = (e.service.type == 'tv') ? 'mov' : 'mp3'
        results << File.join(REDUX_URL,str) if str =~ /.*\.#{filter}$/
      end

      e.links = results
      episodes_to_use << e unless results.empty?
    end

    brand.episodes = episodes_to_use
    brand
  end
end
