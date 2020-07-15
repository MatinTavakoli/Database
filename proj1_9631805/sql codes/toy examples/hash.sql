CREATE FUNCTION hash(IN x VARCHAR, OUT res VARCHAR)
AS '
    BEGIN
        SELECT MD5(x) INTO res;
    END;'
LANGUAGE plpgsql;
SELECT hash('as3f12');