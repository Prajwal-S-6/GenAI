package com.learn.mcp;

import com.learn.mcp.models.ChatRequest;
import com.learn.mcp.models.ChatResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/chat")
public class ChatController {

    private final EcommerceChatService ecommerceChatService;

    public ChatController(EcommerceChatService ecommerceChatService) {
        this.ecommerceChatService = ecommerceChatService;
    }

    @PostMapping
    public ResponseEntity<ChatResponse> chat(@RequestBody ChatRequest request) {
        long start = System.currentTimeMillis();

        String sessionId = request.sessionId() != null
                ? request.sessionId()
                : UUID.randomUUID().toString();

        String reply = ecommerceChatService.chat(sessionId, request.message());

        return ResponseEntity.ok(
                new ChatResponse(reply, sessionId, System.currentTimeMillis() - start)
        );
    }

    @DeleteMapping("/{sessionId}")
    public ResponseEntity<Void> clear(@PathVariable String sessionId) {
        ecommerceChatService.removeSession(sessionId);
        return ResponseEntity.noContent().build();
    }
}
