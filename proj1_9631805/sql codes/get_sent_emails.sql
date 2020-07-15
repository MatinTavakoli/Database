CREATE FUNCTION get_sent_emails(IN l INTEGER, IN p INTEGER)
RETURNS TABLE (id INTEGER,
    subject VARCHAR, t TIMESTAMP, message VARCHAR,
    is_deleted BOOLEAN)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            RETURN QUERY SELECT email.id, email.subject, email.time, email.message, email_sender.is_deleted FROM email, email_sender
            WHERE email_sender.sender_email = CONCAT(signed_in_username, '@foofle.com')
            AND
            email.id = email_sender.id
            AND email_sender.is_deleted <> TRUE
            ORDER BY id DESC LIMIT l OFFSET (l*(p-1));
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM get_sent_emails(4, 1);