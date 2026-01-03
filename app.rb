require 'sinatra'
require 'sinatra/json'
require 'dotenv/load'

# In-memory data store for demo purposes
tasks = [
  { id: 1, title: 'Learn Ruby', completed: false },
  { id: 2, title: 'Build an API', completed: false }
]

# Root endpoint returning API information
get '/' do
  json({
    message: 'Welcome to Ruby API - Server Compass Demo',
    app_name: ENV['APP_NAME'],
    environment: ENV['ENVIRONMENT'],
    public_version: ENV['PUBLIC_VERSION'],
    api_url: ENV['API_URL'],
    version: '1.0.0',
    endpoints: {
      'GET /': 'API information',
      'GET /health': 'Health check',
      'GET /env': 'Environment variables (public only)',
      'GET /api/tasks': 'Get all tasks',
      'GET /api/tasks/:id': 'Get a specific task',
      'POST /api/tasks': 'Create a new task',
      'PUT /api/tasks/:id': 'Update a task',
      'DELETE /api/tasks/:id': 'Delete a task'
    }
  })
end

# Health check endpoint
get '/health' do
  json({
    status: 'healthy',
    timestamp: Time.now.utc.iso8601
  })
end

# Environment variables endpoint (public variables only)
get '/env' do
  json({
    success: true,
    public_variables: {
      app_name: ENV['APP_NAME'],
      api_url: ENV['API_URL'],
      environment: ENV['ENVIRONMENT'],
      public_version: ENV['PUBLIC_VERSION']
    },
    note: 'Private variables (DATABASE_URL, API_SECRET_KEY) are not exposed'
  })
end

# Get all tasks
get '/api/tasks' do
  json({
    success: true,
    data: tasks,
    count: tasks.length
  })
end

# Get a specific task by ID
get '/api/tasks/:id' do
  task_id = params[:id].to_i
  task = tasks.find { |t| t[:id] == task_id }

  if task.nil?
    status 404
    json({
      success: false,
      error: 'Task not found'
    })
  else
    json({
      success: true,
      data: task
    })
  end
end

# Create a new task
post '/api/tasks' do
  request_payload = JSON.parse(request.body.read, symbolize_names: true)

  if request_payload[:title].nil? || request_payload[:title].empty?
    status 400
    return json({
      success: false,
      error: 'Title is required'
    })
  end

  new_task = {
    id: tasks.empty? ? 1 : tasks.last[:id] + 1,
    title: request_payload[:title],
    completed: request_payload.fetch(:completed, false)
  }

  tasks << new_task

  status 201
  json({
    success: true,
    data: new_task,
    message: 'Task created successfully'
  })
end

# Update an existing task
put '/api/tasks/:id' do
  task_id = params[:id].to_i
  task = tasks.find { |t| t[:id] == task_id }

  if task.nil?
    status 404
    return json({
      success: false,
      error: 'Task not found'
    })
  end

  begin
    request_payload = JSON.parse(request.body.read, symbolize_names: true)
  rescue JSON::ParserError
    status 400
    return json({
      success: false,
      error: 'Invalid request data'
    })
  end

  task[:title] = request_payload[:title] if request_payload[:title]
  task[:completed] = request_payload[:completed] unless request_payload[:completed].nil?

  json({
    success: true,
    data: task,
    message: 'Task updated successfully'
  })
end

# Delete a task
delete '/api/tasks/:id' do
  task_id = params[:id].to_i
  task = tasks.find { |t| t[:id] == task_id }

  if task.nil?
    status 404
    return json({
      success: false,
      error: 'Task not found'
    })
  end

  tasks.delete(task)

  json({
    success: true,
    message: 'Task deleted successfully'
  })
end

# Error handlers
not_found do
  json({
    success: false,
    error: 'Endpoint not found'
  })
end

error do
  json({
    success: false,
    error: 'Internal server error'
  })
end
