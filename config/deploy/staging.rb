# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{rails@opensoftware.pl}
role :web, %w{deploy@opensoftware.pl}
role :db,  %w{deploy@opensoftware.pl}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'opensoftware.pl', user: 'rails', roles: %w{web app}

# fetch(:default_env).merge!(rails_env: :staging)
