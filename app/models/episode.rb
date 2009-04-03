class Episode
  attr_accessor :pid,:redux_link, :start, :title, 
                :links, :subtitle, :service, :description,
                :cached_last

  def initialize
    @service = nil
    @title = nil
    @subtitle = nil
    @description = nil
    @start = nil
    @cached_last = nil
    @pid = nil
    @redux_link = nil 
    @links = []
  end

  def image
    "http://node2.bbcimg.co.uk/iplayer/images/episode/#{self.pid}_314_176.jpg"
  end

  def media_link
    self.links.last
  end

  def redux_url
    File.join(
      REDUX_URL,
      'programme', 
      self.service.key, 
      self.start.strftime('%Y-%m-%d/%H-%M-%S')
    )
  end

  def display_title
    t = self.title == '' ? nil : self.title
    s = self.subtitle == '' ? nil : self.subtitle
    [t,s].compact.join(', ')
  end

  def audio_mime_type
    if self.service.type == 'tv'
      'video/quicktime' 
    else
      'audio/mpeg'
    end
  end
end
