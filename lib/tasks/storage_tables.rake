# frozen_string_literal: true

namespace :storage_tables do
  # Prevent migration installation task from showing up twice.
  Rake::Task["install:migrations"].clear_comments

  desc "Install storage tables"
  task :install do
    # Task goes here
  end
end
