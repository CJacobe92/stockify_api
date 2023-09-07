#!/bin/sh

# Exit this if any failure occurs
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

bundle exec rails db:migrate
bundle exec rails db:seed

# After the commands above execute the container's main process.
exec "$@"