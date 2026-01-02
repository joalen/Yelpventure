package com.joalen.mockyelpserver.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/ai")
public class YelpController {
    @PostMapping("/chat/v2")
    public Map<String, Object> chat(@RequestBody Map<String, Object> body)
    {
        return Map.of(
            "response", Map.of(
                "text", "Mock AI response based on query: " + body.get("query"),
                "tags", List.of()
            ),
                "chat_id", "mock-chat-123",
                "entities", List.of(
                        Map.of(
                            "id", "mock-1",
                            "name", "Mock Business",
                            "rating", 4.7,
                            "location", Map.of("city", "Test City")
                        )
                )
        );
    }
}
