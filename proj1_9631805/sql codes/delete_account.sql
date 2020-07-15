CREATE FUNCTION delete_account
    (OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            DELETE FROM access_table
            WHERE administrating_user = signed_in_username OR accesed_user = signed_in_username;

            DELETE FROM notifications WHERE username = signed_in_username;
            UPDATE notifications SET message = REPLACE(message, signed_in_username, 'deletedaccount');



            ALTER TABLE email_recipient_list DROP CONSTRAINT email_recipient_list_id_sender_email_fkey;
            ALTER TABLE email_cc_recipient_list DROP CONSTRAINT email_cc_recipient_list_id_sender_email_fkey;

            UPDATE email_sender SET sender_email = 'deletedaccount@foofle.com' WHERE sender_email = CONCAT(signed_in_username, '@foofle.com');

            UPDATE email_recipient_list SET recipient_email = 'deletedaccount@foofle.com'
            WHERE recipient_email = CONCAT(signed_in_username, '@foofle.com');
            UPDATE email_recipient_list SET sender_email = 'deletedaccount@foofle.com'
            WHERE sender_email = CONCAT(signed_in_username, '@foofle.com');

            UPDATE email_cc_recipient_list SET cc_recipient_email = 'deletedaccount@foofle.com'
            WHERE cc_recipient_email = CONCAT(signed_in_username, '@foofle.com');
            UPDATE email_cc_recipient_list SET sender_email = 'deletedaccount@foofle.com'
            WHERE sender_email = CONCAT(signed_in_username, '@foofle.com');

            ALTER TABLE email_recipient_list ADD CONSTRAINT email_recipient_list_id_sender_email_fkey FOREIGN KEY (id, sender_email) REFERENCES email_sender(id, sender_email);
            ALTER TABLE email_cc_recipient_list ADD CONSTRAINT email_cc_recipient_list_id_sender_email_fkey FOREIGN KEY (id, sender_email) REFERENCES email_sender(id, sender_email);



            DELETE FROM time_table WHERE username = signed_in_username;

            DELETE FROM account WHERE username = signed_in_username;

            SELECT 'account deleted completely!' INTO res;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT delete_account();