#!/usr/bin/env bash
# exit on error
set -o errexit

# Add the environment variable here
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1

bundle install
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed