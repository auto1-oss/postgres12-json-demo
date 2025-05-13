/*
 * This file is part of the auto1-oss/postgres12-json-demo.
 *
 * (c) AUTO1 Group SE https://www.auto1-group.com
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

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
