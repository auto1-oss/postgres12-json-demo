package com.auto1.postgres12;

import com.auto1.postgres12.jpa.Order;
import com.auto1.postgres12.jpa.OrderRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.sql.ResultSet;
import java.util.Scanner;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@Slf4j
@RequiredArgsConstructor
@RestController
public class Controller {

    private static String JSON_QUERY = readClasspathFile("json_query.sql");

    private final OrderRepository orderRepository;
    private final JdbcTemplate jdbcTemplate;
    private final ObjectMapper objectMapper;

    @GetMapping(path = "/v1/orders/{order_id}", produces = APPLICATION_JSON_VALUE)
    public Order getEntity(@PathVariable("order_id") Integer orderId) {
        return orderRepository.findById(orderId).orElseThrow();
    }

    @SneakyThrows
    @GetMapping(path = "/v2/orders/{order_id}", produces = APPLICATION_JSON_VALUE)
    public String getRawBodyFromDatabase(@PathVariable("order_id") Integer orderId) {
        return jdbcTemplate.query(JSON_QUERY, (ResultSet rs) -> {
            rs.next();
            return rs.getString(1);
        }, orderId);
    }

    @SneakyThrows
    @GetMapping(path = "/v3/orders/{order_id}", produces = APPLICATION_JSON_VALUE)
    public Order getEntityNotUsingJpa(@PathVariable("order_id") Integer orderId) {
        return jdbcTemplate.query(JSON_QUERY, (ResultSet rs) -> {
            rs.next();
            return unmarshall(rs.getString(1), Order.class);
        }, orderId);
    }

    @SneakyThrows
    private <T> T unmarshall(String json_body, Class<T> clazz) {
        return objectMapper.readValue(json_body, clazz);
    }

    private static String readClasspathFile(String fileName) {
        var inputStream = Controller.class.getClassLoader().getResourceAsStream(fileName);
        return new Scanner(inputStream).useDelimiter("\\A").next();
    }

}
