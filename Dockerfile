FROM ruby:2.6.3-alpine3.10
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
RUN apk add --no-cache --virtual build-dependencies \
  build-base
# Nokogiri deps
RUN apk add --no-cache \
  libxml2-dev \
  libxslt-dev
# Postgresql deps
RUN apk add --no-cache \
  postgresql-dev \
  postgresql-client
# Webpacker deps
RUN apk add --no-cache \
  nodejs \
  yarn
# Rails runtime deps
RUN apk add --no-cache \
  tzdata \
  ca-certificates
RUN update-ca-certificates
# capybara-webkit \
# libqt4-webkit \
# libqt4-dev \
# xvfb
# Nmap runtime deps
RUN apk add --no-cache \
  nmap \
  nmap-scripts \
  nmap-nselibs \
  sudo
RUN echo 'User_Alias RAILS = #10001' >> /etc/sudoers && \
    echo 'RAILS ALL=(ALL) NOPASSWD:/usr/bin/nmap' >> /etc/sudoers
RUN mkdir /app \
  /app/file_storage \
  /app/log
RUN chown -R 10001:10001 /app
USER 10001:10001
ENV HOME="/app"
WORKDIR /app
RUN gem install bundler && \
    bundle config build.nokogiri --use-system-libraries && \
    rm -rf /usr/lib/lib/ruby/gems/*/cache/*
RUN gem install bundler -v 1.17.3
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 8 --retry 3 --without development test
#RUN bundle install --binstubs --jobs 8 --retry 3
ENV PATH="/app/bin:${PATH}"
COPY package.json yarn.lock ./
RUN yarn install --check-files
# Remove packages that not needed for rails runtime
# RUN apk del build-dependencies
COPY --chown=10001:10001 . ./
RUN RAILS_ENV=production rails assets:precompile
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
