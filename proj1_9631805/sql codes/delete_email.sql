CREATE FUNCTION delete_email(IN email_id INTEGER, OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF (SELECT email_sender.id FROM email_sender
            WHERE email_sender.id = email_id AND email_sender.sender_email = CONCAT(signed_in_username, '@foofle.com'))
            IS NOT NULL THEN
                UPDATE email_sender SET is_deleted = TRUE
                WHERE email_sender.id = email_id AND email_sender.sender_email = CONCAT(signed_in_username, '@foofle.com');
                SELECT 'email deleted!' INTO res;

            ELSIF (SELECT email_recipient_list.id FROM email_recipient_list
            WHERE email_recipient_list.id = email_id AND email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com'))
            IS NOT NULL THEN
                UPDATE email_recipient_list SET is_deleted = TRUE
                WHERE email_recipient_list.id = email_id AND email_recipient_list.recipient_email = CONCAT(signed_in_username, '@foofle.com');
                SELECT 'email deleted!' INTO res;

            ELSIF (SELECT email_cc_recipient_list.id FROM email_cc_recipient_list
            WHERE email_cc_recipient_list.id = email_id AND email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com'))
            IS NOT NULL THEN
                UPDATE email_cc_recipient_list SET is_deleted = TRUE
                WHERE email_cc_recipient_list.id = email_id AND email_cc_recipient_list.cc_recipient_email = CONCAT(signed_in_username, '@foofle.com');
                SELECT 'email deleted!' INTO res;

            ELSE
                RAISE EXCEPTION 'access denied!';
            END IF;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM delete_email(11);
