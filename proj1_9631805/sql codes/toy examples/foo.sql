CREATE FUNCTION foo(a int, b int DEFAULT 2, c int DEFAULT 3)
RETURNS int
LANGUAGE SQL
AS $$
 SELECT $1 + $2 + $3;
$$;

SELECT foo(10, 20, 30);

SELECT foo(10, 110);

SELECT foo(7);

