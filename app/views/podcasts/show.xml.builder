xml.instruct!
xml.rss(:version => '2.0', 'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd', 'xmlns:atom' => 'http://www.w3.org/2005/Atom') do
  xml.channel do
    xml.tag!('atom:link', :href => podcast_url(:guid => to_guid(@brand.pid)), :rel => 'self', :type => 'application/rss+xml')
    xml.title CGI.unescapeHTML(@brand.title)
    xml.link @brand.programmes_link
    xml.language 'en-uk'
    xml.copyright 'http://www.bbc.co.uk'
    xml.tag!('itunes:subtitle', CGI.unescapeHTML(@brand.subtitle))
    xml.tag!('itunes:author', 'http://www.bbc.co.uk')
    xml.tag!('itunes:summary', CGI.unescapeHTML(@brand.subtitle))
    xml.description @brand.subtitle 
    xml.tag!('itunes:image', :href => @brand.image) 
    xml.category 'BBC'
    xml.tag!('itunes:explicit', 'No')
    xml.tag!('itunes:category', :text => 'BBC')
    unless @brand.episodes.empty?
      xml.lastBuildDate @brand.episodes.first.start.rfc2822
    end
    xml.ttl 60
    @brand.episodes.each do |episode|
      xml.item do
        xml.title CGI.unescapeHTML(episode.display_title)
        xml.tag!('itunes:author', episode.service.title)
        xml.tag!('itunes:explicit', 'No')
        xml.tag!('itunes:keywords', "redux, bbc, programmes, #{episode.service.type}")
        xml.tag!('itunes:subtitle', CGI.unescapeHTML(episode.description))
        xml.tag!('itunes:summary', CGI.unescapeHTML(episode.description))
        xml.enclosure(:url => episode.media_link, :length => 0, :type => episode.audio_mime_type)
        xml.guid episode.redux_url
        xml.pubDate episode.start.rfc2822
        xml.link episode.redux_url
      end
    end
  end
end
