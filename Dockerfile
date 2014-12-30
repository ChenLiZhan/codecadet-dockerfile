FROM ubuntu:14.04

MAINTAINER ChenLiZhan "https://github.com/chenlizhan"

# Installing basic stuf: wget, git, ruby
# These are dependencies for compiling gems with native extentions like Nokogiri 
RUN apt-get update
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y libxslt-dev libxml2-dev
RUN apt-get install -y wget git-core

# Installing Ruby 
RUN apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
RUN wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
RUN tar xvfz ruby-2.1.5.tar.gz
WORKDIR /ruby-2.1.5
RUN ./configure
RUN make
RUN sudo make install

# Installing Bundler
RUN gem install bundler

# injecting private key from host into container
RUN mkdir -p /root/.ssh
ADD RELATIVE_PATH_TO_SSH_KEY /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# git clone codecadet
RUN git clone git@github.com:ISS-SOA/codecadet.git /root/codecadet
RUN bundle install --gemfile=/root/codecadet/Gemfile

EXPOSE 4567

WORKDIR /root/codecadet
CMD ["rackup", "-p", "4567"]