package com.example.demo;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.SpanContext;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@SpringBootApplication
@RestController
public class Application {

    private final RestTemplate restTemplate = new RestTemplate();
    private static final Logger log = LoggerFactory.getLogger(Application.class);


    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @SuppressWarnings("unused")
    @GetMapping("/hello")
    public String hello() {
        return "Hello, OpenTelemetry!";
    }

    @SuppressWarnings("unused")
    @GetMapping("/predict-age")
    public ResponseEntity<String> predictAge(@RequestParam String name, @RequestHeader(value = "trace-id", required = false) String traceId) {
        SpanContext ctx = Span.current().getSpanContext();
        String currentTraceId =  ctx.getTraceId();
        Span.current().setAttribute("custom.trace_id", currentTraceId);

        log.info("Generated trace ID: {}", currentTraceId);

        //If incoming traceId header is missing, use current Trace ID
        String effectiveTraceId = (traceId != null) ? traceId : currentTraceId;

        // You can pass this traceId downstream in headers or log it
          HttpHeaders headers = new HttpHeaders();
          headers.set("trace-id", effectiveTraceId);
          HttpEntity<String> entity = new HttpEntity<>(headers);

          ResponseEntity<Map> response = restTemplate.exchange(
                "https://api.agify.io/?name=" + name,
                HttpMethod.GET,
                entity,
                Map.class
        );
        // Log the traceId for debugging
        assert response.getBody() != null;
        String body = response.getBody().toString();

       // return "Predicted age for " + name + ": " + response.getBody().get("age");
        return new ResponseEntity<>(body, headers, HttpStatus.OK);
    }
    }

