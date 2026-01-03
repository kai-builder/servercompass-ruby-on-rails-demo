# Welcome — Rails Demo Now Runs

Use the setup script to install gems (in a path without spaces), run migrations, and seed sample data:

```bash
cd "$(dirname "$0")"
bin/setup
BUNDLE_PATH=/tmp/servercompass-bundle bundle exec rails server -p 3000
```

Key endpoints:
- `/` — HTML env demo
- `/health` — health check
- `/env` — public environment variables
- `/api/tasks` — task CRUD

See `README.md` for details and troubleshooting tips.
