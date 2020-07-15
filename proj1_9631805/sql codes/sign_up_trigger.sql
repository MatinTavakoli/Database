CREATE OR REPLACE FUNCTION sign_up_trigger() RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO notifications (username, message, time) VALUES(LOWER(new.username), 'Welcome to the foofle email system!', (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
        RETURN NULL;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER sign_up_trigger AFTER INSERT ON account FOR EACH ROW
    EXECUTE FUNCTION sign_up_trigger();