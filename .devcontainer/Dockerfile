# [Choice] Ruby version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.0, 2, 2.7, 2.6, 3-bullseye, 3.0-bullseye, 2-bullseye, 2.7-bullseye, 2.6-bullseye, 3-buster, 3.0-buster, 2-buster, 2.7-buster, 2.6-buster
ARG VARIANT=2-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${VARIANT}

ARG bundler_version=2.6.9

USER root

ENV BUNDLER_VERSION="$bundler_version"
RUN gem install bundler --no-document -v "$bundler_version"
RUN bundle config set --local ignore_funding_requests true && \
  bundle config set --local ignore_messages true && \
  bundle config set --local silence_root_warning true

WORKDIR /app

COPY . .
