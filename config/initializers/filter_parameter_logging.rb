# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters = Rails.application.config.filter_parameters + [:password, :employer_id_number]
