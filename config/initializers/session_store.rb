# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_yp_session',
  :secret      => '738b20736ba7f7c3be4777b09bbe50a61d88d82397e6b0c77dec0e20207665c9e64cff001a9bc9f9d21bd2d2079e38700b900fbcbb8f052c8c829e437ce85bcf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
