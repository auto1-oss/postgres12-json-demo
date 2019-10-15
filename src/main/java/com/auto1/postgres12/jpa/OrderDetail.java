package com.auto1.postgres12.jpa;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

@Data
@Entity
@Table(name = "order_details")
@IdClass(OrderDetailPK.class)
public class OrderDetail implements Serializable {

    @Id
    private Integer orderId;

    @Id
    private Integer productId;

    @ManyToOne
    @MapsId("productId")
    @JoinColumn(name = "product_id")
    private Product product;

    private Float unitPrice;
    private Integer quantity;
    private Float discount;
}
