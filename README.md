# Spring Boot Observability Demo with Spring Boot, OpenTelemetry, Tempo, Prometheus, and Grafana
This project demonstrates end-to-end observability using only open-source tools. It includes a Spring Boot application with distributed tracing configured using OpenTelemetry, metrics collection via Prometheus, and visualization in Grafana with Tempo as the trace store.

# What is Prometheus?
Prometheus is an open-source monitoring system that collects metrics from configured targets and stores them for querying and alerting.

# What is Grafana?
Grafana is an open-source analytics and visualization tool that allows you to query, visualize, and alert on data sources like Prometheus and Tempo.

Prerequisites
•	Java 17+
•	Maven
•	Docker + Docker Compose
•	Git

How to Run the Project

1. Clone the Repository

git clone https://github.com/your-username/your-repo.git
cd your-repo

2. Make Scripts Executable

chmod +x start-observability.sh stop-observability.sh

3. Start Everything (App + Tempo + Prometheus + Grafana)

./start-observability.sh

This will:
•	Check required ports and Docker daemon
•	Build and launch the Spring Boot app
•	Start Docker containers for Tempo, Prometheus, and Grafana
•	Open Grafana and Prometheus in your browser

4. Access Services
   •	Spring Boot App: http://localhost:8080
   •	Prometheus: http://localhost:9090
   •	Grafana: http://localhost:3000 (login: admin / admin)
   •	Tempo UI (query endpoint): http://localhost:3200

5. Generate Traces

Call your API endpoint to generate a trace:

# curl "http://localhost:8080/predict-age?name=John"

The response will include a trace ID in the header or body, which you can use to search in Grafana Tempo.

6. View Traces in Grafana
   •	Go to Explore in Grafana
   •	Select Tempo as the data source
   •	Paste the trace ID returned from the app and run the query

# Stop Everything
./stop-observability.sh
This will stop all containers and the Spring Boot app.



Feel free to modify the configuration files to fit your environment!