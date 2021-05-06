FROM ruby:3.0.1-alpine3.13

ENV BUNDLER_VERSION='2.2.15'

RUN apk add --update --no-cache \
      build-base \
      nodejs \
      postgresql-dev \
      tzdata \
      yarn

RUN gem install bundler --no-document -v '2.2.15'

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install

COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . ./

RUN chmod +x ./docker-entrypoint.sh
RUN chmod +x ./init.sql

ENTRYPOINT ["./docker-entrypoint.sh"]
