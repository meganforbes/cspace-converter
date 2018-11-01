FROM alpine:3.6

ENV BUILD_PACKAGES="bash build-base curl curl-dev dcron nodejs ruby-dev tzdata" \
    RUBY_PACKAGES="ruby ruby-io-console ruby-irb ruby-json libffi-dev zlib-dev ruby-bigdecimal" \
    TERM=linux \
    PS1="\n\n>> ruby \W \$ " \
    TZ=UTC

RUN apk --no-cache add $BUILD_PACKAGES $RUBY_PACKAGES && \
    echo 'gem: --no-document' > /etc/gemrc && gem install bundler && \
    bundle config --global silence_root_warning 1

RUN mkdir -p /usr/app/
WORKDIR /usr/app

COPY Gemfile* /usr/app/
RUN bundle install

COPY . /usr/app/
CMD crond && bundle exec whenever --update-crontab && bundle exec rails s -b 0.0.0.0
