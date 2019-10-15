package com.auto1.postgres12.jpa;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@Data
public class Order implements Serializable {

    @Id
    private Integer orderId;

//    private String customerId;
    private Integer employeeId;

    private LocalDate orderDate;
    private LocalDate requiredDate;
    private LocalDate shippedDate;
    private Integer shipVia;
    private Float freight;
    private String shipName;
    private String shipAddress;
    private String shipCity;
    private String shipRegion;
    private String shipPostalCode;
    private String shipCountry;

    @OneToMany
    @JoinColumn(name = "order_id")
    private List<OrderDetail> orderDetails = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "customer_id")
    private Customer customer;
}
