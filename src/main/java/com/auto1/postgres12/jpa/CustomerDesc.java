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

@Entity
@Table(name = "customer_demographics")
@Data
public class CustomerDesc {
    @Id
    private String customerTypeId;

    private String customerDesc;
}
