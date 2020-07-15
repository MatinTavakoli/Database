CREATE FUNCTION read_email(IN email_id INTEGER)
RETURNS TABLE (id INTEGER,
                sender_email VARCHAR,
                subject VARCHAR, t TIMESTAMP, message VARCHAR,
                is_read BOOLEAN, is_deleted BOOLEAN)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF (SELECT email_sender.id FROM email_sender
            WHERE email_sender.id = email_id
            AND
            email_sender.sender_email = CONCAT(signed_in_username, '@foofle.com')
            AND
            email_sender.is_deleted <> TRUE)
            IS NOT NULL THEN
                RETURN QUERY SELECT DISTINCT email.id, email_sender.sender_email, email.subject, email.time, email.message, TRUE, email_sender.is_deleted
                FROM email, email_sender WHERE email.id = email_id
                                         AND email_sender.id = email_id
                                         AND email_sender.sender_email = CONCAT(signed_in_username, '@foofle.com')
                                         AND email_sender.is_deleted <> TRUE;

            ELSIF (SELECT email_recipient_list.id FROM email_recipient_list
            WHERE email_recipient_list.id = email_id
            AND
            email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com')
            AND
            email_recipient_list.is_deleted <> TRUE)
            IS NOT NULL THEN
                UPDATE email_recipient_list SET is_read = TRUE
                WHERE email_recipient_list.id = email_id
                AND email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com')
                AND email_recipient_list.is_deleted <> TRUE;
                RETURN QUERY SELECT DISTINCT email.id, email_sender.sender_email, email.subject, email.time, email.message, email_recipient_list.is_read, email_recipient_list.is_deleted
                FROM email, email_sender, email_recipient_list WHERE email.id = email_id
                                                               AND email_sender.id = email_id
                                                               AND email_recipient_list.id = email_id
                                                               AND email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com')
                                                               AND email_recipient_list.is_deleted <> TRUE;

            ELSIF (SELECT email_cc_recipient_list.id FROM email_cc_recipient_list
            WHERE email_cc_recipient_list.id = email_id
            AND
            email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com')
            AND
            email_cc_recipient_list.is_deleted <> TRUE)
            IS NOT NULL THEN
                UPDATE email_cc_recipient_list SET is_read = TRUE
                WHERE email_cc_recipient_list.id = email_id
                AND email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com')
                AND email_cc_recipient_list.is_deleted <> TRUE;
                RETURN QUERY SELECT DISTINCT email.id, email_sender.sender_email, email.subject, email.time, email.message, email_cc_recipient_list.is_read, email_cc_recipient_list.is_deleted
                FROM email, email_sender, email_cc_recipient_list WHERE email.id = email_id
                                                                  AND email_sender.id = email_id
                                                                  AND email_cc_recipient_list.id = email_id
                                                                  AND email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com')
                                                                  AND email_cc_recipient_list.is_deleted <> TRUE;

            ELSE
                RAISE EXCEPTION 'access denied!';
            END IF;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM read_email(11);
