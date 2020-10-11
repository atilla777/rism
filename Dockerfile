FROM ruby:2.6.3-alpine3.10
#ENV RACK_ENV=production RAILS_ENV=production
ENV RAILS_LOG_TO_STDOUT=true
ENV BUNDLER_VERSION=1.17.3

ENV USER=rails
ENV UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" "${USER}"
RUN apk update
# build essentials
RUN apk add --no-cache --virtual build-dependencies \
  #alpine-sdk \
  build-base
  #git
  #curl
# nokogiri
RUN apk add --no-cache \
  libxml2-dev \
  libxslt-dev
# postgresql
RUN apk add --no-cache \
  postgresql-dev
  #libpq
# nodejs
RUN apk add --no-cache \
  nodejs \
  yarn
# rails runtime
RUN apk add --no-cache \
  tzdata \
  ca-certificates
#capybara-webkit
#libqt4-webkit
#libqt4-dev
#xvfb

RUN apk add --no-cache \
  nmap \
  nmap-scripts \
  nmap-nselibs
#RUN apk add --no-cache \
#  build-base \
#  curl \
#  linux-headers \
#  nmap \
#  nmap-scripts \
#  nmap-nselibs \
#  tzdata \
#  git \
#  unzip \
#  file \
#  yaml-dev \
#  zip \
#  zlib-dev

RUN update-ca-certificates
RUN mkdir /app \
  /app/file_storage

RUN chown -R 10001:10001 /app
#RUN chown -R 10001:10001 /usr/local/bundle

#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh

USER 10001:10001
RUN gem install bundler && \
    bundle config build.nokogiri --use-system-libraries && \
    rm -rf /usr/lib/lib/ruby/gems/*/cache/*

WORKDIR /app
#RUN gem install bundler -v 2.1.4
RUN gem install bundler -v 1.17.3
ADD Gemfile* ./
RUN bundle install --jobs 8 --retry 3
COPY package.json yarn.lock ./
RUN yarn install --check-files
# Remove packages that not needed for rails runtime
RUN apk del build-dependencies
COPY --chown=10001:10001 . ./

RUN rails assets:precompile

EXPOSE 3000

#ENTRYPOINT ["entrypoint.sh"]
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
#ENTRYPOINT ["rails-entrypoint.sh"]
