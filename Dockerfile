FROM ghcr.io/stevehipwell/fluentd-aggregator:latest


# Use root account to use apk
USER root

# Add custom plugins
RUN set -eu; \
  apk --no-cache add --virtual .build-deps build-base autoconf automake libtool ruby-dev; \
  apk --no-cache add geoip-dev; \
  gem install fluent-plugin-geoip; \
  gem install fluent-plugin-concat; \
  gem sources --clear-all; \
  apk del .build-deps; \
  rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem;

# Set back to non-root user
USER fluent
