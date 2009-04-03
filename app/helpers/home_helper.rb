module HomeHelper

  def recent_subscriptions
    subs = []
    sorted = Dir.glob(File.join(RAILS_ROOT, "tmp/cache", "**", "*.xml.cache")).sort_by {|f| test(?M, f)}
    sorted.each do |fn|
      subs << File.open(fn, 'rb') { |f| Marshal.load(f) } rescue []
    end
    subs.reverse[0...5]
  end

end
