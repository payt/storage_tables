# [Choice] Ruby version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.0, 2, 2.7, 2.6, 3-bullseye, 3.0-bullseye, 2-bullseye, 2.7-bullseye, 2.6-bullseye, 3-buster, 3.0-buster, 2-buster, 2.7-buster, 2.6-buster
ARG VARIANT=2-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

ARG bundler_version=2.6.9

USER root

RUN useradd -m -s /bin/bash -G rvm,nvm runner && \
  echo "runner ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner && \
  chmod 0440 /etc/sudoers.d/runner

RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y curl gnupg lsb-release && \
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
  apt-get update && apt-get install -y postgresql-client-18 && \
  rm -rf /var/lib/apt/lists/*

ENV BUNDLER_VERSION="$bundler_version"
RUN gem install bundler --no-document -v "$bundler_version"
RUN bundle config set --local ignore_funding_requests true && \
  bundle config set --local ignore_messages true && \
  bundle config set --local silence_root_warning true

WORKDIR /app

COPY . .

RUN bundle install

# `bundle install` above runs as root, so the shared rvm gem directory ends up
# root-owned. postCreateCommand runs later `bundle install`s as the non-root
# `runner` user (see devcontainer.json's remoteUser), so hand it ownership.
RUN chown -R runner:runner /app "$(gem env gemdir)" && \
  git config --system --add safe.directory '*' && \
  git config --system core.hardlinks false && \
  git config --system core.excludesfile '~/.gitignore'