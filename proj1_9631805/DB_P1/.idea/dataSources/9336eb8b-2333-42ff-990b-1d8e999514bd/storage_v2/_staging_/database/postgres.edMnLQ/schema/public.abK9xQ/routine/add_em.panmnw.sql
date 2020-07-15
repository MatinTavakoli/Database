create or replace function add_em(integer, integer) returns integer
    language sql
as
$$
SELECT $1 + $2;
$$;

alter function add_em(1, 2) owner to postgres;