#!/bin/bash

echo "Stopping Spring Boot + Tempo + Prometheus + Grafana..."

# Kill Spring Boot app
APP_PID=$(pgrep -f 'java.*target/.*\.jar')
if [ -n "$APP_PID" ]; then
  echo "Stopping Spring Boot (PID: $APP_PID)..."
  kill $APP_PID
else
  echo "Spring Boot app not running."
fi

# Stop Docker services
echo "Stopping Docker containers..."
docker-compose -f docker-compose-tempo.yml down --remove-orphans

# Final port check
echo "Cleanup done. Checking for leftover services:"
lsof -i :9090