FROM ruby:3.2.2-alpine

RUN apk update && \
    apk add --no-cache build-base nodejs postgresql-dev postgresql-client tzdata && \
    gem update --system && \
    gem install bundler:2.2.28

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Add a script to be executed every time the container starts.
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
