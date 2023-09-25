# frozen_string_literal: true

SimpleCov.start do
  enable_coverage :branch
  primary_coverage :branch

  add_filter "/test/"

  SimpleCov.minimum_coverage 100
end
