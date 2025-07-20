# Spring Boot Observability with OpenTelemetry, Prometheus, and Grafana

This project demonstrates how to add observability to a Spring Boot application using OpenTelemetry for instrumentation, Prometheus for metrics collection, and Grafana for visualization.

---

## 🔍 What Is Prometheus?

**Prometheus** is an open-source monitoring and alerting toolkit. It collects and stores time-series data — like request counts, error rates, or response durations — by scraping metrics endpoints (e.g. `/actuator/prometheus`) exposed by services.

- Pull-based metrics collection
- Powerful query language (PromQL)
- Native integration with Grafana
- Designed for reliability even if other systems fail

---

## 📈 What Is Grafana?

**Grafana** is an open-source analytics and visualization platform. It allows you to:

- Connect to multiple data sources (like Prometheus, Tempo, etc.)
- Create and customize real-time dashboards
- Explore and search logs and traces
- Visualize metrics with rich graphs, tables, heatmaps, and more

---

## ✅ Prerequisites

- Java 17+ installed
- Maven installed
- Docker & Docker Compose installed and running
- Git (optional)

---

## 🚀 Getting Started

### 1. Clone the Repository (if applicable)

```bash
git clone <your-repo-url>
cd <your-project-directory>