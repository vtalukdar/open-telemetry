
# OpenTelemetry Spring Boot Demo (Auto-Instrumented)

## 🛠 Build the Project

```bash
mvn clean package
```

## 📥 Download OpenTelemetry Java Agent

Download from:  
https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar

Place it in the same folder as the project.

## 🚀 Run the App with Agent



## 📊 Run Jaeger (Tracing UI)

```bash
docker-compose up -d
```

Visit: [http://localhost:16686](http://localhost:16686)

## 🧪 Test the App

```bash
curl http://localhost:8080/hello
curl "http://localhost:8080/predict-age?name=lucy"
```
