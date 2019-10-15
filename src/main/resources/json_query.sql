WITH products("productId", "categoryId", "supplierId", "productName", "discontinued", "quantityPerUnit",
              "unitPrice", "unitsInStock", "unitsOnOrder", "reorderLevel") AS
         (SELECT p.product_id,
                 p.category_id,
                 p.supplier_id,
                 p.product_name,
                 p.discontinued::boolean,
                 p.quantity_per_unit,
                 p.unit_price,
                 p.units_in_stock,
                 p.units_on_order,
                 p.reorder_level
          FROM products p),

     orderDetails("orderId", "productId", "product", "unitPrice", "quantity", "discount") AS
         (SELECT d.order_id,
                 d.product_id,
                 (SELECT to_json(p) FROM products p WHERE p."productId" = d.product_id),
                 d.unit_price,
                 d.quantity,
                 d.discount
          FROM order_details d),


     demographics("customerId", "customerTypeId", "customerDesc") AS
         (SELECT ccd.customer_id,
                 ccd.customer_type_id,
                 cd.customer_desc
          FROM customer_demographics cd
                   JOIN customer_customer_demo ccd on cd.customer_type_id = ccd.customer_type_id),

     customers("customerId", "companyName", "contactName", "contactTitle", "address", "city", "region", "postalCode",
               "country", "phone", "fax", "customerDesc") AS
         (SELECT c.customer_id,
                 c.company_name,
                 c.contact_name,
                 c.contact_title,
                 c.address,
                 c.city,
                 c.region,
                 c.postal_code,
                 c.country,
                 c.phone,
                 c.fax,
                 (SELECT to_json(array_agg(to_json(d))) FROM (SELECT "customerTypeId", "customerDesc" FROM demographics WHERE demographics."customerId" = c.customer_id) d)
          FROM customers c),


     orders("orderId", "employeeId", "orderDate", "requiredDate", "shippedDate", "shipVia", "freight",
            "shipName", "shipAddress", "shipCity", "shipRegion", "shipPostalCode", "shipCountry", "orderDetails",
            "customer") AS
         (SELECT o.order_id,
                 o.employee_id,
                 o.order_date,
                 o.required_date,
                 o.shipped_date,
                 o.ship_via,
                 o.freight,
                 o.ship_name,
                 o.ship_address,
                 o.ship_city,
                 o.ship_region,
                 o.ship_postal_code,
                 o.ship_country,
                 (SELECT to_json(array_agg(to_json(d))) FROM orderDetails d WHERE d."orderId" = o.order_id),
                 (SELECT to_json(c) FROM customers c WHERE c."customerId" = o.customer_id)
          FROM orders o)

SELECT to_json(orders) AS json_body FROM orders WHERE orders."orderId" = ?