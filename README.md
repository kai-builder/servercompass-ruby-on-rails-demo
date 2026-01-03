# Ruby API Demo - Server Compass

A simple Ruby REST API for managing tasks with CRUD operations and environment variable demonstration using Sinatra framework.

## Features

- RESTful API endpoints
- Task management (Create, Read, Update, Delete)
- Environment variable configuration using `.env` file with `dotenv`
- Public vs private environment variable handling
- Health check endpoint
- Error handling
- JSON responses

## Prerequisites

- Ruby 2.6 or higher
- Bundler gem

## Installation

1. Install Bundler if you haven't already:
```bash
gem install bundler
```

2. Install dependencies:
```bash
bundle install
```

3. Set up environment variables:
```bash
# Copy the example file
cp .env.example .env

# Edit .env with your actual values
```

## Environment Variables

The application uses the following environment variables (defined in `.env`):

### Public Variables (exposed via `/env` endpoint)
- `APP_NAME` - Application name (e.g., "ServerCompass Ruby on Rail")
- `API_URL` - API base URL (e.g., "https://api.servercompass.app")
- `ENVIRONMENT` - Current environment (production, development, etc.)
- `PUBLIC_VERSION` - Public version number (e.g., "1.0.0")

### Private Variables (NOT exposed to clients)
- `DATABASE_URL` - Database connection string
- `API_SECRET_KEY` - Secret key for API authentication

**Note:** The `dotenv` gem automatically loads variables from `.env`.

## Running the Application

### Quick Start

```bash
./start.sh
```

### Manual Start

```bash
# Using Ruby with bundler
bundle exec ruby app.rb

# Or using Rackup (recommended for production)
bundle exec rackup -p 4567

# Or using Puma directly
bundle exec puma -p 4567
```

The API will be available at `http://localhost:4567`

## API Endpoints

### Root
- **GET** `/` - Get API information, available endpoints, and public environment variables

### Health Check
- **GET** `/health` - Check API health status

### Environment Variables
- **GET** `/env` - Get public environment variables (demonstrates .env usage)

### Tasks
- **GET** `/api/tasks` - Get all tasks
- **GET** `/api/tasks/:id` - Get a specific task by ID
- **POST** `/api/tasks` - Create a new task
- **PUT** `/api/tasks/:id` - Update a task
- **DELETE** `/api/tasks/:id` - Delete a task

## Usage Examples

### Get API info with environment variables
```bash
curl http://localhost:4567/
```

### Get public environment variables
```bash
curl http://localhost:4567/env
```

### Get all tasks
```bash
curl http://localhost:4567/api/tasks
```

### Get a specific task
```bash
curl http://localhost:4567/api/tasks/1
```

### Create a new task
```bash
curl -X POST http://localhost:4567/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "New Task", "completed": false}'
```

### Update a task
```bash
curl -X PUT http://localhost:4567/api/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Updated Task", "completed": true}'
```

### Delete a task
```bash
curl -X DELETE http://localhost:4567/api/tasks/1
```

## Response Format

All responses are in JSON format with the following structure:

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message"
}
```

### Error Response
```json
{
  "success": false,
  "error": "Error message"
}
```

## Environment Variable Demonstration

This project demonstrates how to:

1. **Load environment variables** using the `dotenv` gem
2. **Differentiate between public and private variables**:
   - Public variables (APP_NAME, API_URL, etc.) are exposed via the `/env` endpoint
   - Private variables (DATABASE_URL, API_SECRET_KEY) are NEVER exposed to clients
3. **Use environment variables** throughout the application (see root endpoint `/`)

### Example: Accessing Environment Variables in Ruby

```ruby
# In app.rb
require 'dotenv/load'

# Access variables
app_name = ENV['APP_NAME']
database_url = ENV['DATABASE_URL']
```

## Project Structure

```
servercompass-ruby-on-rails-demo/
├── app.rb              # Main Sinatra application
├── config.ru           # Rack configuration
├── Gemfile             # Ruby dependencies
├── .env                # Environment variables (not committed)
├── .env.example        # Environment variables template
├── .gitignore          # Git ignore rules
├── start.sh            # Quick start script
└── README.md           # This file
```

## Security Notes

- The `.env` file is included in `.gitignore` to prevent committing secrets to version control
- Always use `.env.example` as a template and create your own `.env` file locally
- Private environment variables (DATABASE_URL, API_SECRET_KEY) are intentionally NOT exposed via API endpoints
- The `/env` endpoint only returns public configuration variables

## Development

This is a demo API using in-memory storage. For production use, consider:
- Adding a database (PostgreSQL, MySQL, SQLite, etc.)
- Implementing authentication and authorization using API_SECRET_KEY
- Adding input validation and sanitization
- Using environment-specific configurations
- Adding logging and monitoring
- Writing tests (RSpec, Minitest)
- Implementing rate limiting
- Adding CORS support if needed

## Comparison with Other Demos

This Ruby API is part of the Server Compass demo project series and includes:
- Task management endpoints (similar to Flask and Django demos)
- Environment variable handling with public/private separation
- RESTful API design
- Health check endpoint
- Comprehensive error handling

## About the Framework

This demo uses **Sinatra**, a lightweight Ruby web framework similar to Flask in Python. While the project folder is named "servercompass-ruby-on-rails-demo" to maintain consistency with other demos, we chose Sinatra for its:
- Simplicity and minimal setup
- Better compatibility with older Ruby versions
- Lightweight footprint ideal for API-only applications
- Easy-to-understand codebase for learning purposes

## License

MIT
