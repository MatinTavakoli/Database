CREATE OR REPLACE FUNCTION send_email_cc_recipient_trigger() RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO notifications VALUES (LOWER(REPLACE(REPLACE(new.cc_recipient_email, 'cc:', ''), '@foofle.com', '')), 'you have received an email!', (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
        RETURN NULL;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER send_email_cc_recipient_trigger AFTER INSERT ON email_cc_recipient_list FOR EACH ROW
    EXECUTE FUNCTION send_email_cc_recipient_trigger();