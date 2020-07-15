CREATE TYPE sum_prod AS (sum int, produce int);

CREATE FUNCTION sum_n_product (int, int) RETURNS sum_prod
AS 'SELECT $1 + $2, $1 * $2'
LANGUAGE SQL;

SELECT sum_n_product(2, 5)
