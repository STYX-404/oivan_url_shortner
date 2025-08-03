FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev


ENV RAILS_ROOT $HOME/app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT


COPY Gemfile* ./
RUN gem install bundler && bundle install --retry 5


ADD . $RAILS_ROOT
COPY ./docker/entrypoint.sh /docker/entrypoint.sh
RUN chmod +x /docker/entrypoint.sh