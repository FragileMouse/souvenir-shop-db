-- 1

SELECT
      COUNT(*) AS amount_of_products
  FROM
      product
      INNER JOIN category ON category.category_id = product.category_id
 WHERE
      category_name = 'Брелки';

-- 2

SELECT
      SUM(amount * price) AS february_income
FROM
      purchase_details
      INNER JOIN product ON product.product_id = purchase_details.product_id
WHERE
      purchase_id IN (
                      SELECT
                            purchase_id
                        FROM
                            purchase
                       WHERE
                            purchase_date >= '2026-02-01'
                            AND purchase_date < '2026-03-01'
                            );

-- 3

WITH
    top_product_table (title, amount) AS (
                                          SELECT
                                                product_name,
                                                SUM(amount) AS full_amount
                                            FROM
                                                purchase_details
                                                INNER JOIN product ON product.product_id = purchase_details.product_id
                                       GROUP BY
                                                product.product_id
                                       ORDER BY
                                                full_amount DESC
                                                )
SELECT
      title AS most_popular
 FROM
      top_product_table
WHERE
      amount = (
                SELECT
                      MAX(amount)
                  FROM
                      top_product_table
                      );

-- 4

SELECT
      city,
      COUNT(purchase_id) AS amount
  FROM
      purchase
      INNER JOIN client ON client.client_id = purchase.client_id
GROUP BY
        city
ORDER BY
        amount DESC;
 
-- 5

WITH
  tab (client_id, client_name, product_id, amount) AS (
    SELECT
      client.client_id,
      client_name,
      product_id,
      SUM(amount)
    FROM
      client
      INNER JOIN purchase ON purchase.client_id = client.client_id
      INNER JOIN purchase_details ON purchase_details.purchase_id = purchase.purchase_id
    GROUP BY
      client.client_id,
      product_id
    ORDER BY
      client_name
  ),
  max_res (client_id, client_name, largest_amount) AS (
    SELECT DISTINCT
      client_id,
      client_name,
      MAX(amount) OVER (
        PARTITION BY
          client_id
      ) AS largest_amount
    FROM
      tab
    ORDER BY
      client_id
  )
SELECT
  tab.client_id,
  tab.client_name,
  amount,
  product.product_id,
  product_name
FROM
  max_res
  INNER JOIN tab ON tab.amount = max_res.largest_amount
  AND tab.client_id = max_res.client_id
  INNER JOIN product ON product.product_id = tab.product_id;

-- 6

SELECT
  *
FROM
  client
WHERE
  client_id NOT IN (
    SELECT DISTINCT
      (client_id)
    FROM
      purchase
  );

-- 7

SELECT
  EXTRACT(
    YEAR
    FROM
      AVG(AGE (CURRENT_DATE, birth_date))
  ) AS average_age
FROM
  client;

-- 8

SELECT
  category_name,
  MAX(price) AS largest_price
FROM
  product
  INNER JOIN category ON category.category_id = product.category_id
GROUP BY
  category.category_id
ORDER BY
  largest_price DESC;

-- 9

SELECT
  CASE
    WHEN EXTRACT(
      MONTH
      FROM
        purchase_date
    ) = 1 THEN 'Январь'
    WHEN EXTRACT(
      MONTH
      FROM
        purchase_date
    ) = 2 THEN 'Февраль'
    ELSE 'Март'
  END AS month_name,
  SUM(amount * price) AS income,
  COUNT(purchase.purchase_id) AS amount
FROM
  purchase
  INNER JOIN purchase_details ON purchase_details.purchase_id = purchase.purchase_id
  INNER JOIN product ON product.product_id = purchase_details.product_id
WHERE
  purchase_date >= '01.01.2026'
  AND purchase_date < '01.04.2026'
GROUP BY
  month_name
ORDER BY
  income DESC;

-- 10

WITH
  count_tab (category_id, amount) AS (
    SELECT
      category_id,
      COUNT(*)
    FROM
      product
    WHERE
      product_id NOT IN (
        SELECT DISTINCT
          product_id
        FROM
          purchase_details
      )
    GROUP BY
      category_id
  )
SELECT
  category_name,
  amount AS amount_of_not_bought
FROM
  count_tab
  INNER JOIN category ON category.category_id = count_tab.category_id
ORDER BY
  amount_of_not_bought DESC;