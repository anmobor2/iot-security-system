package com.iot.security.deviceservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.iot.security.deviceservice.model.Device;
import com.iot.security.deviceservice.model.Event;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
public class DeviceService {

    private final DynamoDbEnhancedClient dynamoDbClient;
    private final DynamoDbTable<Device> deviceTable;
    private final DynamoDbTable<Event> eventTable;
    private final ObjectMapper objectMapper;

    public DeviceService(DynamoDbEnhancedClient dynamoDbClient, ObjectMapper objectMapper) {
        this.dynamoDbClient = dynamoDbClient;
        this.deviceTable = dynamoDbClient.table("Devices", TableSchema.fromBean(Device.class));
        this.eventTable = dynamoDbClient.table("Events", TableSchema.fromBean(Event.class));
        this.objectMapper = objectMapper;
    }

    public Device registerDevice(Device device) {
        deviceTable.putItem(device);
        log.info("Registered device: {}", device.getDeviceId());
        return device;
    }

    public Optional<Device> getDevice(String deviceId) {
        return Optional.ofNullable(deviceTable.getItem(r -> r.key(k -> k.partitionValue(deviceId))));
    }

    public List<Device> getAllDevices() {
        return deviceTable.scan().items().stream().collect(Collectors.toList());
    }

    public Device updateDevice(Device device) {
        deviceTable.updateItem(device);
        log.info("Updated device: {}", device.getDeviceId());
        return device;
    }

    public void deleteDevice(String deviceId) {
        deviceTable.deleteItem(r -> r.key(k -> k.partitionValue(deviceId)));
        log.info("Deleted device: {}", deviceId);
    }

    @KafkaListener(topics = "security.sensors.events", groupId = "device-service-group", errorHandler = "kafkaErrorHandler")
    public void consumeEvent(String eventJson) {
        try {
            Event event = parseEvent(eventJson);
            eventTable.putItem(event);
            log.info("Processed event from device: {}, type: {}", event.getDeviceId(), event.getEventType());
        } catch (Exception e) {
            log.error("Error processing Kafka event: {}", eventJson, e);
            throw e; // Rethrow for error handler
        }
    }

    private Event parseEvent(String eventJson) {
        try {
            Event event = objectMapper.readValue(eventJson, Event.class);
            if (event.getDeviceId() == null || event.getEventType() == null || event.getTimestamp() == null) {
                log.error("Missing required fields in event JSON: {}", eventJson);
                throw new IllegalArgumentException("Missing required fields in event JSON");
            }
            if (event.getDetails() == null) {
                event.setDetails("{}");
            }
            return event;
        } catch (Exception e) {
            log.error("Failed to parse event JSON: {}", eventJson, e);
            throw new RuntimeException("Invalid event JSON", e);
        }
    }
}