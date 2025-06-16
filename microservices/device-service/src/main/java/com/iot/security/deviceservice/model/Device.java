package com.iot.security.deviceservice.model;

import lombok.Data;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbBean;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbPartitionKey;

@Data
@DynamoDbBean
public class Device {
    private String deviceId;
    private String type; // e.g., "motion_sensor", "camera"
    private String location; // e.g., "warehouse1"
    private String status; // e.g., "active", "inactive"

    @DynamoDbPartitionKey
    public String getDeviceId() {
        return deviceId;
    }
}