# Ruby on Rails API Demo - Server Compass

A lightweight Rails 5.2 API-only app that demonstrates task CRUD and a frontend page that echoes environment variables.

## Quick start
1. Ensure Ruby 2.6+ and Bundler are available (the system Ruby on macOS works).
2. Copy the env file and update values as needed:
   ```bash
   cp .env.example .env
   ```
3. Install gems and set up the database. The setup script installs gems to `/tmp/servercompass-bundle` by default to avoid native extension issues with spaces in the project path:
   ```bash
   bin/setup
   ```
   Or manually:
   ```bash
   BUNDLE_PATH=/tmp/servercompass-bundle BUNDLE_FORCE_RUBY_PLATFORM=1 bundle install
   bundle exec rails db:migrate db:seed
   ```
4. Start the API:
   ```bash
   BUNDLE_PATH=/tmp/servercompass-bundle bundle exec rails server -p 3000
   ```
5. Test the endpoints:
   - `http://localhost:3000/` — HTML env demo (shows `Not set` for missing values)
   - `GET http://localhost:3000/health`
   - `GET http://localhost:3000/api/tasks`

## API
- `GET /` — HTML page that lists public/private env variables
- `GET /health` — simple health check with timestamp
- `GET /env` — public environment variables only
- `GET /api/tasks` — list tasks
- `GET /api/tasks/:id` — show a task
- `POST /api/tasks` — create (`{ task: { title, completed } }`)
- `PUT /api/tasks/:id` — update
- `DELETE /api/tasks/:id` — delete

## Data model
`Task` has `title:string` (required), `completed:boolean` (default `false`), and timestamps. Seeds add two sample tasks idempotently.

## Environment variables
- Public: `APP_NAME`, `API_URL`, `ENVIRONMENT`, `VERSION`
- Private (displayed in the HTML demo but not in the JSON endpoint): `DATABASE_URL`, `API_SECRET_KEY`
- The included `DATABASE_URL` is for display only; the app still connects to SQLite so you can run without the `pg` gem. If you truly want to use Postgres, set `USE_DATABASE_URL_FOR_RAILS=true` and add the `pg` gem.

## Notes
- Bundler installs to `/tmp/servercompass-bundle` by default to avoid native extension build failures when the project path contains spaces; override `BUNDLE_PATH` if you prefer another location without spaces.
- SQLite is used in development; `DATABASE_URL` is kept only for display unless you opt in with `USE_DATABASE_URL_FOR_RAILS=true`.
- The `VERSION` env var is captured for display so it doesn't clash with Rails migration tasks; set `USE_VERSION_FOR_RAILS=true` if you need the raw env var.
- CORS is open to all origins for demo purposes.

## License
MIT
