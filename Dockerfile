FROM ghcr.io/railwayapp/nixpacks:ubuntu-1745885067

ENTRYPOINT ["/bin/bash", "-l", "-c"]
WORKDIR /app/



RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends procps git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

ARG BUNDLE_GEMFILE GEM_HOME GEM_PATH MALLOC_ARENA_MAX NIXPACKS_METADATA RAILS_LOG_TO_STDOUT RAILS_SERVE_STATIC_FILES
ENV BUNDLE_GEMFILE=$BUNDLE_GEMFILE GEM_HOME=$GEM_HOME GEM_PATH=$GEM_PATH MALLOC_ARENA_MAX=$MALLOC_ARENA_MAX NIXPACKS_METADATA=$NIXPACKS_METADATA RAILS_LOG_TO_STDOUT=$RAILS_LOG_TO_STDOUT RAILS_SERVE_STATIC_FILES=$RAILS_SERVE_STATIC_FILES

# setup phase
ENV NIXPACKS_PATH=$HOME/.rbenv/bin:$NIXPACKS_PATH
RUN  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash -s stable && printf '\neval "$(~/.rbenv/bin/rbenv init -)"' >> /root/.profile && . /root/.profile && rbenv install >= 2.6.0 && rbenv global >= 2.6.0 && gem install bundler:1.17.2

# install phase
ENV NIXPACKS_PATH=/usr/local/rvm/rubies/ruby->=2.6.0/bin:/usr/local/rvm/gems/ruby->=2.6.0/bin:/usr/local/rvm/gems/ruby->=2.6.0@global/bin:$NIXPACKS_PATH
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN --mount=type=cache,id=qGlzefqvHw-/root/bundle/cache,target=/root/.bundle/cache bundle install

# build phase
COPY . /app/.
RUN  bundle exec rake assets:precompile

RUN printf '\nPATH=$HOME/.rbenv/bin:$PATH' >> /root/.profile
RUN printf '\nPATH=/usr/local/rvm/rubies/ruby->= 2.6.0/bin:/usr/local/rvm/gems/ruby->= 2.6.0/bin:/usr/local/rvm/gems/ruby->= 2.6.0@global/bin:$PATH' >> /root/.profile


# start
COPY . /app

CMD ["bundle exec bin/rails server -b 0.0.0.0 -p ${PORT:-3000} -e $RAILS_ENV"]