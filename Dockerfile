FROM ruby:2.4.1
MAINTAINER asapontenhou@gmail.com

ENV LANG C.UTF-8
ENV WORKING_DIR var/www/html

WORKDIR $WORKING_DIR

RUN apt-get update && \
    apt-get install -y vim \
                       nodejs \
                       sqlite3

COPY Gemfile $WORKING_DIR
COPY Gemfile.lock $WORKING_DIR

# update bundler
RUN gem install bundler
RUN cd Soco
RUN bundle install

EXPOSE 3000
