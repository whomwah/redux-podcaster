module HomeHelper

  def recent_subscriptions
    subs = []
    Dir.glob(File.join(RAILS_ROOT, "tmp/cache", "**", "*.xml.cache")).each do |fn|
      subs << File.open(fn, 'rb') { |f| Marshal.load(f) } rescue []
      break if subs.size >= 5
    end
    subs.reverse
  end

end
