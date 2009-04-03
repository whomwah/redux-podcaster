module HomeHelper

  def recent_subscriptions
    subs = []
    Dir.glob(File.join(RAILS_ROOT, "tmp/cache", "**", "*.xml.cache")).each do |fn|
      subs << File.open(fn, 'rb') { |f| Marshal.load(f) } rescue []
    end
    subs.reverse[0...5]
  end

end
