CREATE FUNCTION send_email
    (IN email_subject VARCHAR,
    IN email_message VARCHAR,
    VARIADIC recipient_list VARCHAR[],
    OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
        recipient VARCHAR;
        all_recipients_valid BOOLEAN := TRUE;
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            FOREACH recipient IN ARRAY recipient_list LOOP
                IF recipient LIKE 'cc:%' THEN
                    IF (SELECT username FROM account WHERE username = LOWER(REPLACE(recipient, 'cc:', ''))) IS NULL THEN
                        all_recipients_valid = FALSE;
                    END IF;
                ELSE
                    IF (SELECT username FROM account WHERE username = LOWER(recipient)) IS NULL THEN
                        all_recipients_valid = FALSE;
                    END IF;
                END IF;
            END LOOP;

            IF all_recipients_valid = TRUE THEN
                INSERT INTO email(subject, time, message) VALUES(email_subject, (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP, email_message);
                INSERT INTO email_sender VALUES(currval(pg_get_serial_sequence('email', 'id')), CONCAT(signed_in_username, '@foofle.com'), FALSE);
                FOREACH recipient IN ARRAY recipient_list LOOP
                    IF recipient LIKE 'cc:%' THEN
                        INSERT INTO email_cc_recipient_list VALUES(currval(pg_get_serial_sequence('email', 'id')), CONCAT(LOWER(REPLACE(recipient, 'cc:', '')), '@foofle.com'), CONCAT(signed_in_username, '@foofle.com'), FALSE, FALSE);
                    ELSE
                        INSERT INTO email_recipient_list VALUES(currval(pg_get_serial_sequence('email', 'id')), CONCAT(LOWER(recipient), '@foofle.com'), CONCAT(signed_in_username, '@foofle.com'), FALSE, FALSE);
                    END IF;
                END LOOP;
                SELECT 'email sent!' INTO res;
            ELSE
                RAISE EXCEPTION 'one of the emails were invalid. please try again!';
            END IF;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;


--'SaJAdSarlaki'
--'cc:MmkH'
SELECT send_email('testing12', 'Hi I am matin!', 'cc:sHaYANshaFAghi', 'hoSseinZaredar', 'sajadsarlaki');