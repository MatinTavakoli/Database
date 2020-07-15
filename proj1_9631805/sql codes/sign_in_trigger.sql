CREATE OR REPLACE FUNCTION sign_in_trigger() RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO notifications VALUES(LOWER(new.username), 'You have signed in successfully!', (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
        RETURN NULL;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER sign_in_trigger AFTER INSERT ON time_table FOR EACH ROW
    EXECUTE FUNCTION sign_in_trigger();