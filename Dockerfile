FROM ruby:3.1.2

ENV TZ=Asia/Tokyo
ARG RUBYGEMS_VERSION=3.3.20

RUN apt update -qq && apt install -y postgresql-client && apt-get install -y libpq-dev

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
COPY . /myapp

RUN gem update --system ${RUBYGEMS_VERSION} && \
    bundle install --path vendor/bundle
#RUN gem update --system ${RUBYGEMS_VERSION}

COPY start.sh /usr/bin/
RUN chmod +x /usr/bin/start.sh
ENTRYPOINT ["start.sh"]
EXPOSE 8080

CMD ["bin/start"]