package com.auto1.postgres12.jpa;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;

@Data
@Entity
@Table(name = "products")
public class Product implements Serializable {

    @Id
    private Integer productId;

    private Integer categoryId;
    private Integer supplierId;
    private String productName;
    private Boolean discontinued;
    private String quantityPerUnit;
    private Float unitPrice;
    private Integer unitsInStock;
    private Integer unitsOnOrder;
    private Integer reorderLevel;

}
