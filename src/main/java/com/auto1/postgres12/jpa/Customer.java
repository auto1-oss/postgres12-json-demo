package com.auto1.postgres12.jpa;

import lombok.Data;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "customers")
@Data
public class Customer {

    @Id
    private String customerId;

    private String companyName;
    private String contactName;
    private String contactTitle;
    private String address;
    private String city;
    private String region;
    private String postalCode;
    private String country;
    private String phone;
    private String fax;

    @ManyToMany
    @JoinTable(name = "customer_customer_demo",
            joinColumns = @JoinColumn(name = "customer_id"),
            inverseJoinColumns = @JoinColumn(name = "customer_type_id"))
    private Set<CustomerDesc> customerDesc;
}
