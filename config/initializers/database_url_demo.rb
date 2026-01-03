# Keep the provided DATABASE_URL value for display, but avoid using it to
# connect to PostgreSQL so the demo can run on SQLite without the pg gem.
if ENV['DATABASE_URL'].present?
  ENV['SERVER_COMPASS_DEMO_DATABASE_URL'] ||= ENV['DATABASE_URL']
  ENV.delete('DATABASE_URL') unless ENV['USE_DATABASE_URL_FOR_RAILS'] == 'true'
end
