class PodcastsController < ApplicationController
  def index
    return redirect_to(root_url) if params[:guid].blank?
    redirect_to(:action => 'show')
  end

  def show
    key = podcast_path(:guid => params[:guid], :year => params[:year])
    @brand = handle_fragment(key,params)
    return custom_404 if @brand.blank? 

    respond_to do |format|
      format.xml
    end
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    custom_404 
  end

  def url
    return render(:status => 404, :template => 'podcasts/show') if params[:pid].blank?
    key = podcast_path(:guid => Obscurer.obscure(params[:pid]), :year => params[:year])
    @brand = handle_fragment(key,params)
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    custom_404
  end

  private

  def handle_fragment(key,options=nil)
    pid = options[:pid] if options.is_a?(Hash) && options.has_key?(:pid)
    pid = pid || Obscurer.unobscure(params[:guid]) if options.is_a?(Hash) && options.has_key?(:guid)
    return nil if pid.blank? 
    expire_fragment(key) unless 
      brand = read_fragment(key, :expires_in => RSS_CACHE_TIME) || write_fragment(key, Redux.data(pid,options))
    return brand
  end

  def custom_404
    render(:status => 404, :template => 'podcasts/show')
  end
end
