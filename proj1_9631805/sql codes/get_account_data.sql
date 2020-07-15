CREATE FUNCTION get_account_data()
RETURNS TABLE (
    account_username VARCHAR(20),
    account_reg_date DATE,
    account_system_phone_number CHAR(12),
    account_address VARCHAR(50),
    account_firstname VARCHAR(20),
    account_lastname VARCHAR(20),
    account_personal_phone_number CHAR(13),
    account_date_of_birth DATE,
    account_known_as VARCHAR(20),
    account_id CHAR(10),
    account_default_access VARCHAR(7)
              )
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            RETURN QUERY SELECT username, reg_date, system_phone_number, address, firstname, lastname, personal_phone_number, date_of_birth, known_as, id, default_access  FROM account WHERE username = signed_in_username;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM get_account_data();