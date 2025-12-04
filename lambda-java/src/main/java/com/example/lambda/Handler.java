package com.example.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

public class Handler implements RequestHandler<Map<String, Object>, Map<String, Object>> {
    
    @Override
    public Map<String, Object> handleRequest(Map<String, Object> event, Context context) {
        LambdaLogger logger = context.getLogger();
        
        // Get name from event, default to "World"
        String name = (String) event.getOrDefault("name", "World");
        
        // Current timestamp
        String timestamp = Instant.now().toString();
        
        // Log invocation
        logger.log("Lambda invoked at " + timestamp + " with name: " + name);
        
        // Construct response
        String message = String.format("Hello, %s! This is a Java Lambda function.", name);
        
        Map<String, Object> responseBody = new HashMap<>();
        responseBody.put("message", message);
        responseBody.put("timestamp", timestamp);
        responseBody.put("runtime", "java17");
        responseBody.put("input", event);
        
        Map<String, Object> response = new HashMap<>();
        response.put("statusCode", 200);
        response.put("body", responseBody);
        
        return response;
    }
}
