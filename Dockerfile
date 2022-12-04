FROM ruby:3.1.3

ENV LANG C.UTF-8

RUN echo "gem: --no-document" > $HOME/.gemrc && \
    touch $HOME/.irb-history && \
    echo "IRB.conf[:SAVE_HISTORY] = 1000\nIRB.conf[:HISTORY_FILE] = '~/.irb-history'" > $HOME/.irbrc
RUN apt-get update -qq && \
    apt-get install -y postgresql-client

RUN mkdir /ruby_app
WORKDIR /ruby_app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.3.26
RUN bundle config --global jobs `grep -c cores /proc/cpuinfo` && \
    bundle config --delete bin
# RUN bundle install

COPY . .

EXPOSE 3000

# Start the main process.
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
