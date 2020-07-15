CREATE FUNCTION get_inbox_emails(IN l INTEGER, IN p INTEGER)
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
            RETURN QUERY
            (SELECT DISTINCT
            email.id, email_sender.sender_email, email.subject, email.time, email.message, email_recipient_list.is_read, email_recipient_list.is_deleted
            FROM email, email_sender, email_recipient_list
            WHERE
            (email.id = email_recipient_list.id AND email.id = email_sender.id)
            AND
            (email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com'))
            AND
            email_recipient_list.is_deleted <> TRUE)
            UNION
            (SELECT DISTINCT
            email.id, email_sender.sender_email, email.subject, email.time, email.message, email_cc_recipient_list.is_read, email_cc_recipient_list.is_deleted
            FROM email, email_sender, email_cc_recipient_list
            WHERE
            (email.id = email_cc_recipient_list.id AND email.id = email_sender.id)
            AND
            (email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com'))
            AND
            email_cc_recipient_list.is_deleted <> TRUE)
            ORDER BY id DESC LIMIT l OFFSET (l*(p-1));
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;


SELECT * FROM get_inbox_emails(5, 1);