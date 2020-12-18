FROM ruby:2.7.2

RUN apt-get update -qq && apt-get install -y build-essential \
  software-properties-common

RUN apt-get clean

# Install GitHub CLI
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
RUN apt-add-repository https://cli.github.com/packages
RUN apt update
RUN apt install gh

RUN gem install github_commit octokit

ENV APP_HOME /opt/resource/
RUN mkdir $APP_HOME

WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
COPY bin/* $APP_HOME
