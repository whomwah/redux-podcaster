class ActiveSupport::Cache::FileStore
  def read(name, options = nil) 
    logger.warn("options: #{options.inspect}")
    ttl = 0
    ttl = options[:expires_in] if options.is_a?(Hash) && options.has_key?(:expires_in)
    fn = real_file_path(name)

    return if ttl > 0 && File.exists?(fn) && (File.mtime(fn) < (Time.now - ttl))
    File.open(fn, 'rb') { |f| Marshal.load(f) } rescue nil
  end
end
