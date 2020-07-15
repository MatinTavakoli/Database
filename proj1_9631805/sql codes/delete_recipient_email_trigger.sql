CREATE OR REPLACE FUNCTION delete_recipient_email_trigger() RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO notifications VALUES (REPLACE(new.recipient_email, '@foofle.com', ''), 'email deleted successfully!', (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
        RETURN NULL;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER delete_recipient_email_trigger AFTER UPDATE ON email_recipient_list FOR EACH ROW
    EXECUTE FUNCTION delete_recipient_email_trigger();