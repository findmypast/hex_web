FROM elixir:1.2.5

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 0527A9B7 \
 && gpg --verify /tini.asc
RUN chmod +x /tini
RUN apt-get update && \
  apt-get -y install curl && \
  curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g brunch

COPY ./mix.exs /usr/src/app/mix.exs
WORKDIR /usr/src/app

# Install elixir dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix do deps.get, deps.compile

# Set environment variables
# ENV MIX_ENV=prod
ENV PORT=4000

COPY . /usr/src/app

# Compile phoenix app
RUN mix compile
RUN brunch build
RUN mix phoenix.digest

# Set tini entrypoint
ENTRYPOINT ["/tini", "--"]

CMD ["mix", "phoenix.server"]
