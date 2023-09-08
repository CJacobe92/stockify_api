#!/bin/sh

# Exit this if any failure occurs
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# export RAILS_ENV=production

export DISABLE_DATABASE_ENVIRONMENT_CHECK=1

bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# After the commands above execute the container's main process.
exec "$@"