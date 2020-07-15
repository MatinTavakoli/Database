CREATE TABLE tab (y int, z int);
INSERT INTO tab VALUES (1, 2), (3, 4), (5, 6), (7, 8);
CREATE FUNCTION sum_n_product_with_tab (x int, OUT sum int, OUT
 product int)
RETURNS SETOF record
AS $$
 SELECT $1 + tab.y, $1 * tab.y FROM tab;
$$ LANGUAGE SQL;
SELECT * FROM sum_n_product_with_tab(10);