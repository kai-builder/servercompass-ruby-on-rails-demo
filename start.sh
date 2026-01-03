#!/bin/bash

echo "========================================="
echo "  Server Compass Ruby API Demo"
echo "========================================="
echo ""

# Check if bundler is installed
if ! command -v bundle &> /dev/null; then
    echo "Bundler not found. Installing..."
    gem install bundler
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Warning: .env file not found!"
    echo "Creating .env from .env.example..."
    cp .env.example .env
    echo "Please edit .env with your actual values"
    echo ""
fi

# Install dependencies if needed
if [ ! -d "vendor/bundle" ]; then
    echo "Installing dependencies..."
    bundle install --path vendor/bundle
    echo ""
fi

echo "Starting Ruby API server on http://localhost:4567"
echo "Press Ctrl+C to stop"
echo ""

# Start the server
bundle exec ruby app.rb -p 4567
