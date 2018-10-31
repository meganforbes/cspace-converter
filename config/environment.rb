# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Setup the logger
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::WARN # at any time

# Initialize the Rails application.
Rails.application.initialize!