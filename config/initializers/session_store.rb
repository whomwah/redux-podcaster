# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_podcaster_session',
  :secret      => 'be5ceb20dca8abb2ce5ec497e3973c58492055174c6427db27bb2cc96478cd8eda036fc38e220fca93d8b732ad7562eee1499bef189d93b9c7515afbc6c64669'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
