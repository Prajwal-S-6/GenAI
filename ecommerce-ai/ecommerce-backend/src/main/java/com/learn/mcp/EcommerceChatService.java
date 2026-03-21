package com.learn.mcp;

import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.model.tool.ToolCallingChatOptions;
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class EcommerceChatService {

    private final OllamaChatModel chatModel;
    private final MethodToolCallbackProvider toolCallbackProvider;
    private final Map<String, List<Message>> sessions = new ConcurrentHashMap<>();

    private static final String SYSTEM_PROMPT = """
        You are an ecommerce analytics assistant.
        You have tools to query the store's database in real time.
        
        Rules:
        - Always call the right tool before answering — never guess numbers
        - Format prices with ₹ symbol and commas (e.g. ₹1,29,000)
        - When you see an insight in the data, mention it proactively
        - Suggest a concrete action when relevant (e.g. run a discount)
        - Keep answers concise but useful
        """;

    public EcommerceChatService(OllamaChatModel chatModel, EcommerceMCPTool ecommerceMCPTool) {
        this.chatModel = chatModel;
        this.toolCallbackProvider = MethodToolCallbackProvider.builder()
                .toolObjects(ecommerceMCPTool)
                .build();
    }

    public String chat(String sessionId, String userMessage) {
        List<Message> history = sessions.computeIfAbsent(
                sessionId, k -> new ArrayList<>());

        history.add(new UserMessage(userMessage));

        // System message + full history
        List<Message> messages = new ArrayList<>();
        messages.add(new SystemMessage(SYSTEM_PROMPT));
        messages.addAll(history);

        Prompt prompt = new Prompt(messages,
                ToolCallingChatOptions.builder()
                        .toolCallbacks(toolCallbackProvider.getToolCallbacks())
                        .internalToolExecutionEnabled(true)
                        .build());

        String reply = chatModel.call(prompt)
                .getResult().getOutput().getText();

        history.add(new AssistantMessage(reply));

        // Keep last 20 messages to avoid context overflow
        if (history.size() > 20) {
            history.subList(0, history.size() - 20).clear();
        }

        return reply;
    }

    public void removeSession(String sessionId) {
        sessions.remove(sessionId);
    }
}
