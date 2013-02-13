# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_siatka_session',
  :secret      => '25587dff2f55ebd9f7395a96237be8c5a7246ddd3a53785fd512fc2d4cd68a00517febeff5b5788d00a2449a2ce2d693112363cee10fd197fcea65bf937d339d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
