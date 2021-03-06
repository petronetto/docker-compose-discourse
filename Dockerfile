FROM rails

WORKDIR /usr/src/app

ENV DISCOURSE_VERSION 1.9.0

RUN curl -L https://github.com/discourse/discourse/archive/v${DISCOURSE_VERSION}.tar.gz \
  | tar -xz -C /usr/src/app --strip-components 1 \
  && bundle install --deployment --without test --without development \
  && mkdir -p /home/discourse/discourse/tmp/sockets

RUN apt-get update && apt-get install -y --no-install-recommends imagemagick libxml2 \
  && rm -rf /var/lib/apt/lists/*


ADD puma.rb /usr/src/app/config/puma.rb

ENV RAILS_ENV production
ENV DISCOURSE_DB_HOST postgres
ENV DISCOURSE_REDIS_HOST redis
ENV DISCOURSE_SERVE_STATIC_ASSETS true

EXPOSE 3000
CMD ["rails", "server"]
