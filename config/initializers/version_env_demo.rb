# Keep the provided VERSION value for display without letting it conflict with
# Active Record's migration VERSION argument.
if ENV['VERSION'].present?
  ENV['SERVER_COMPASS_DEMO_VERSION'] ||= ENV['VERSION']
  ENV.delete('VERSION') unless ENV['USE_VERSION_FOR_RAILS'] == 'true'
end
