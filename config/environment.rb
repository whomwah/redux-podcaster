# Be sure to restart your server when you modify this file
require 'nokogiri'
require 'open-uri'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

require 'file_store_expires'

CONFIG = YAML::load(File.read(File.expand_path('~')+'/configs/redux.yaml'))
MAX_EPISODES = 20
REDUX_URL = 'http://g.bbcredux.com'
CREDENTIALS = {
  'username' => CONFIG[:login][:username], 
  'password' => CONFIG[:login][:password],
  'dologin' => 1
}
SALT = CONFIG[:login][:salt]
SERVICES = {
  'BBC Radio 1' => 
    { :key => 'bbcr1', :type => 'radio' },
  'BBC Radio 2' => 
    { :key => 'bbcr2', :type => 'radio' },
  'BBC Radio 3' => 
    { :key => 'bbcr3', :type => 'radio' },
  'BBC Radio 4' => 
    { :key => 'bbcr4', :type => 'radio' },
  'BBC Radio 5 live' => 
    { :key => 'bbcr5l', :type => 'radio' },
  'BBC Radio 5 live sports extra' => 
    { :key => 'r5lsx', :type => 'radio' },
  'BBC 6 Music' => 
    { :key => 'bbc6m', :type => 'radio' },
  'BBC Radio 7' => 
    { :key => 'bbc7', :type => 'radio' },
  'BBC 1Xtra' => 
    { :key => 'bbc1x', :type => 'radio' },
  'BBC Asian Network' => 
    { :key => 'bbcan', :type => 'radio' },
  'BBC One' => 
    { :key => 'bbcone', :type => 'tv' },
  'BBC Two' => 
    { :key => 'bbctwo', :type => 'tv' },
  'CBeebies' => 
    { :key => 'cbeebies', :type => 'tv' },
  'CBBC' => 
    { :key => 'cbbc', :type => 'tv' },
  'BBC Three' => 
    { :key => 'bbcthree', :type => 'tv' },
  'BBC Four' => 
    { :key => 'bbcfour', :type => 'tv' },
  'BBC News Channel' => 
    { :key => 'bbcnews24', :type => 'tv' },
  'BBC Parliament' => 
    { :key => 'bbcparl', :type => 'tv' },
}
