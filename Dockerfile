FROM ruby:2.4.1
MAINTAINER asapontenhou@gmail.com

ENV LANG C.UTF-8
ENV WORKING_DIR /var/www/html/SocoAPI

WORKDIR $WORKING_DIR

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs vim

ADD ./SocoAPI/Gemfile $WORKING_DIR
ADD ./SocoAPI/Gemfile.lock $WORKING_DIR

# update bundler
RUN gem install bundler
# bundle install
RUN bundle install
