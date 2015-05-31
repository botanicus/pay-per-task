FROM ruby:2.2.2-slim

ENV ROOT /app/ppt.inbox.pt

RUN mkdir -p $ROOT
WORKDIR $ROOT

RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*

ADD . $ROOT
RUN bundle install

CMD ["bundle", "exec", "./consumer.rb"]
