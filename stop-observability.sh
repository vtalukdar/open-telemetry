#!/bin/bash

echo "🛑 Stopping Spring Boot + Prometheus + Grafana..."

# Find and kill Spring Boot app by searching for the jar name (adjust if needed)
APP_PID=$(pgrep -f 'java.*target/.*\.jar')

if [ -n "$APP_PID" ]; then
  echo "Stopping Spring Boot (PID: $APP_PID)..."
  kill $APP_PID
  # Wait a bit for it to stop
  sleep 5
else
  echo "Spring Boot app is not running."
fi

# Stop Prometheus and Grafana containers
echo "Stopping Prometheus and Grafana Docker containers..."
docker-compose -f docker-compose-prometheus.yml down

echo "✅ All services stopped."
