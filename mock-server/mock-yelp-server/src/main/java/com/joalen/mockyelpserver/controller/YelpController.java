package com.joalen.mockyelpserver.controller;

import com.opencsv.CSVReaderHeaderAware;
import com.opencsv.exceptions.CsvValidationException;
import org.springframework.core.io.ClassPathResource;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;

@RestController
@RequestMapping("/ai")
public class YelpController {
    private final List<Map<String, String>> businesses = new ArrayList<>();
    private final Random random = new Random();

    public YelpController() throws CsvValidationException, IOException {
        try
        {
            ClassPathResource resource = new ClassPathResource("businesses.csv");

            if (resource.exists())
            {
                try (CSVReaderHeaderAware reader = new CSVReaderHeaderAware(new InputStreamReader(resource.getInputStream())))
                {
                    Map<String, String> row;
                    while ((row = reader.readMap()) != null)
                    {
                        businesses.add(row);
                    }
                }
            }
            else
            {
                throw new FileNotFoundException("You'll need to provide a business.csv file or dataset of local businesses!");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
    @PostMapping("/chat/v2")
    public Map<String, Object> chat(@RequestBody Map<String, Object> body)
    {
        String query = body.get("query").toString();
        List<Map<String, Object>> entities = new ArrayList<>();
        if (businesses.isEmpty()) {
            return Map.of(
                    "response", Map.of("text", "No businesses loaded!", "tags", List.of()),
                    "chat_id", "mock-chat-123",
                    "entities", List.of()
            );
        }

        Map<String, String> biz = businesses.get(random.nextInt(businesses.size()));
        Map<String, Object> entity = Map.of(
                "id", biz.get("id"),
                "name", biz.get("name"),
                "categories", List.of(Map.of(
                        "title", biz.get("category"),
                        "alias", biz.get("alternate_categories")
                )),
                "location", Map.of(
                        "address1", biz.get("address"),
                        "city", biz.get("city"),
                        "state", biz.get("state"),
                        "zip_code", biz.get("zipcode"),
                        "country", biz.get("country")
                ),
                "coordinates", Map.of(
                        "latitude", Objects.requireNonNull(parseDoubleSafe(biz.get("lat"))),
                        "longitude", Objects.requireNonNull(parseDoubleSafe(biz.get("lon")))
                ),
                "phone", biz.get("phones"),
                "attributes", Map.of(
                        "BusinessUrl", biz.get("websites"),
                        "FacebookUrl", biz.get("facebook"),
                        "BusinessTempClosed", "closed".equalsIgnoreCase(biz.get("operating_status"))
                )
        );

        return Map.of(
                "response", Map.of(
                        "text", "Here’s a random business for you: " + biz.get("name"),
                        "tags", List.of()
                ),
                "chat_id", "mock-chat-123",
                "entities", List.of(entity)
        );
    }

    private Double parseDoubleSafe(String value) {
        try
        {
            return value != null ? Double.parseDouble(value) : null;
        } catch (Exception e)
        {
            return null;
        }
    }
}