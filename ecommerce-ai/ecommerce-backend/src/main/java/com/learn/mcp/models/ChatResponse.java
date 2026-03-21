package com.learn.mcp.models;

public record ChatResponse(String message, String sessionId, Long responseTime) {
}
