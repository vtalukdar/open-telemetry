
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import java.net.http.HttpHeaders;
import java.util.Map;

@SpringBootApplication
@RestController
public class Application {

    private final RestTemplate restTemplate = new RestTemplate();

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @GetMapping("/hello")
    public String hello() {
        return "Hello, OpenTelemetry!";
    }

    @GetMapping("/predict-age")
    public String predictAge(@RequestParam String name, @RequestHeader(value = "trace-id", required = false) String traceId) {
        //    Span currentSpan = Span.current();
        //   String currentTraceId = currentSpan.getSpanContext().getTraceId();

        // If incoming traceId header is missing, use current Trace ID
        //String effectiveTraceId = (traceId != null) ? traceId : currentTraceId;

        // You can pass this traceId downstream in headers or log it
        // Example: pass as header to the downstream HTTP call
        //  HttpHeaders headers = new HttpHeaders();
        //  headers.set("trace-id", effectiveTraceId);
        //  HttpEntity<String> entity = new HttpEntity<>(headers);

        HttpEntity<String> entity = null;
        ResponseEntity<Map> response = restTemplate.exchange(
                "https://api.agify.io/?name=" + name,
                HttpMethod.GET,
                entity,
                Map.class
        );
        // Log the traceId for debugging
     //   log.info("Trace ID: {}", effectiveTraceId);

        return "Predicted age for " + name + ": " + response.getBody().get("age");
    }
    }

