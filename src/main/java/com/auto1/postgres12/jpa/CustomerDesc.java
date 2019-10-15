package com.auto1.postgres12.jpa;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "customer_demographics")
@Data
public class CustomerDesc {
    @Id
    private String customerTypeId;

    private String customerDesc;
}
