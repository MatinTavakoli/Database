CREATE FUNCTION get_notifications() RETURNS SETOF notifications
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            RETURN QUERY SELECT * FROM notifications WHERE username = signed_in_username ORDER BY time DESC;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM get_notifications();
