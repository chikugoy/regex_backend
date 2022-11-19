FROM ruby:3.1

ENV TZ=Asia/Tokyo
ARG RUBYGEMS_VERSION=3.3.20

RUN apt update -qq && apt install -y postgresql-client && apt-get install -y libpq-dev

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY . /myapp

#RUN gem update --system ${RUBYGEMS_VERSION} && \
#    bundle install --path vendor/bundle
RUN gem update --system ${RUBYGEMS_VERSION}

COPY docker/web/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]