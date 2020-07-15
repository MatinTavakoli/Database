CREATE FUNCTION variable_arg(VARIADIC recipient_list VARCHAR[], OUT res VARCHAR)
AS
    $$
    DECLARE
        recipient_email VARCHAR;
    BEGIN
        FOREACH recipient_email IN ARRAY recipient_list LOOP
            IF recipient_email LIKE 'cc:%' THEN
                INSERT INTO cc_recipient VALUES(LOWER(recipient_email));
            ELSE
                INSERT INTO recipient VALUES(LOWER(recipient_email));
            END IF;
        END LOOP;
        SELECT 'all good!' INTO res;
    END;
    $$
LANGUAGE plpgsql;

SELECT variable_arg('HossienZaredar@foofle.com', 'ShayanShafaghi@foofle.com', 'SajadSarlaki@foofle.com', 'cc:MMKH@foofle.com');