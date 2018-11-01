# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Setup the logger
LOG_LEVEL = ENV.fetch('CSPACE_CONVERTER_LOG_LEVEL', 'warn').upcase
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = "Logger::#{LOG_LEVEL}".constantize

# Initialize the Rails application.
Rails.application.initialize!
