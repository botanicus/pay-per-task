# https://github.com/docker-library/ruby/blob/4ccabb5557ce2001aa1ae2a5f719340eb33c0383/2.2/slim/Dockerfile
FROM ruby:2.2.2-slim

ENV ROOT /app/ppt.inbox.pt/

RUN mkdir -p $ROOT
WORKDIR $ROOT

# We need make & gcc for building native extensions (EventMachine).
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

ADD Gemfile Gemfile.lock $ROOT
RUN bundle install

ADD . $ROOT

CMD ["bundle", "exec", "./consumer.rb"]
