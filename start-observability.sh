#!/bin/bash

echo "Starting Spring Boot + Tempo + Prometheus + Grafana setup..."

chmod +x "$0"

# Check Docker daemon
check_docker() {
  if ! docker info > /dev/null 2>&1; then
    echo "Docker daemon is not running or not reachable."
    echo "Please start Docker and try again."
    exit 1
  fi
  echo "Docker daemon is running."
}

# Ports to check
PORTS=(8080 9090 3000 3200 4317 4318)

check_ports() {
  for port in "${PORTS[@]}"; do
    if lsof -iTCP:"$port" -sTCP:LISTEN -t >/dev/null ; then
      echo "Port $port is already in use. Please free it before running the script."
      exit 1
    fi
  done
  echo "All required ports are free."
}

cleanup() {
  echo "Cleaning up services..."
  echo "Stopping Spring Boot (PID: $APP_PID)..."
  kill $APP_PID 2>/dev/null
  echo "Stopping Docker Compose services..."
  docker-compose -f docker-compose-tempo.yml down
  exit 1
}

wait_for_service() {
  local url=$1
  local name=$2
  local max_retries=10
  local retry_count=0

  until curl -s "$url" > /dev/null; do
    retry_count=$((retry_count+1))
    if [ "$retry_count" -ge "$max_retries" ]; then
      echo "$name failed to start after $max_retries attempts."
      cleanup
    fi
    echo "Waiting for $name to start... ($retry_count/$max_retries)"
    sleep 3
  done
  echo "$name is running"
}

check_docker
check_ports

echo "Starting Tempo, Prometheus, and Grafana..."
docker-compose -f docker-compose-tempo.yml up -d --remove-orphans

wait_for_service "http://localhost:9090" "Prometheus"
wait_for_service "http://localhost:3000" "Grafana"
wait_for_service "http://localhost:3200" "Tempo"

echo "🔨 Building Spring Boot application..."
if mvn clean package -DskipTests; then
  echo "Build successful"
else
  echo "Build failed"
  cleanup
fi

echo "Running Spring Boot app with OpenTelemetry Java agent..."
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
export OTEL_SERVICE_NAME=spring-boot-app
export OTEL_TRACES_EXPORTER=otlp

if [ ! -f "opentelemetry-javaagent.jar" ]; then
  echo "Downloading OpenTelemetry Java agent..."
  curl -L https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar -o opentelemetry-javaagent.jar
fi

java -javaagent:opentelemetry-javaagent.jar \
     -jar target/*.jar \
     > spring-boot.log 2>&1 &
APP_PID=$!

wait_for_service "http://localhost:8080/actuator/health" "Spring Boot"

echo ""
echo "All systems are up and running!"
echo "Spring Boot: http://localhost:8080"
echo "Prometheus:  http://localhost:9090"
echo "Grafana:     http://localhost:3000 (login: admin / admin)"
echo "Tempo (traces): http://localhost:3200"

# Open browser tabs if possible
if which xdg-open > /dev/null; then
  xdg-open http://localhost:3000
elif which open > /dev/null; then
  open http://localhost:3000
fi


docker-compose -f docker-compose-tempo.yml logs -f prometheus &
docker-compose -f docker-compose-tempo.yml logs -f grafana &
docker-compose -f docker-compose-tempo.yml logs -f tempo &

wait