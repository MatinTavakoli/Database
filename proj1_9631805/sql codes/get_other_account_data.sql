CREATE FUNCTION get_other_account_data(IN uname VARCHAR)
RETURNS TABLE (other_username VARCHAR,
    other_address VARCHAR,
    other_firstname VARCHAR,
    other_lastname VARCHAR,
    other_personal_phone_number CHAR,
    other_date_of_birth DATE,
    other_known_as VARCHAR,
    other_id CHAR,
    other_default_access VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF (SELECT username FROM account WHERE username = LOWER(uname)) IS NOT NULL THEN
                IF LOWER(uname) = signed_in_username THEN
                    RAISE EXCEPTION 'this is yourself! use get_account_data() instead.';
                ELSE
                    IF (SELECT administrating_user FROM access_table WHERE administrating_user = LOWER(uname) AND accesed_user = signed_in_username) IS NOT NULL THEN
                        IF (SELECT access_mode FROM access_table WHERE administrating_user = LOWER(uname) AND accesed_user = signed_in_username) = 'granted' THEN
                            INSERT INTO notifications VALUES(LOWER(uname), FORMAT('user %s wanted to access your account data. access was granted.', signed_in_username), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                            RETURN QUERY SELECT username,
                                address, firstname,
                                lastname, personal_phone_number,
                                date_of_birth, known_as, id, default_access
                                FROM account WHERE username = LOWER(uname);
                        ELSE
                            INSERT INTO notifications VALUES(LOWER(uname), FORMAT('user %s wanted to access your account data. access was denied.', signed_in_username), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                            RETURN QUERY SELECT
                                '*'::VARCHAR, '*'::VARCHAR AS address,
                                '*'::VARCHAR AS firstname, '*'::VARCHAR AS lastname,
                                '*'::CHAR AS personal_phone_number, '0001-01-01'::DATE AS date_of_birth,
                                '*'::VARCHAR AS known_as, '*'::CHAR AS id, '*'::VARCHAR AS default_access
                                FROM account WHERE username = LOWER(uname);
                        END IF;
                    ELSIF (SELECT default_access FROM account WHERE username = LOWER(uname)) = 'always' THEN
                        INSERT INTO notifications VALUES(LOWER(uname), FORMAT('user %s wanted to access your account data. access was granted.', signed_in_username), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                        RETURN QUERY SELECT username,
                            address, firstname,
                            lastname, personal_phone_number,
                            date_of_birth, known_as, id, default_access
                            FROM account WHERE username = LOWER(uname);
                    ELSE
                        INSERT INTO notifications VALUES(LOWER(uname), FORMAT('user %s wanted to access your account data. access was denied.', signed_in_username), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                        RETURN QUERY SELECT
                            '*'::VARCHAR, '*'::VARCHAR AS address,
                            '*'::VARCHAR AS firstname, '*'::VARCHAR AS lastname,
                            '*'::CHAR AS personal_phone_number, '0001-01-01'::DATE AS date_of_birth,
                            '*'::VARCHAR AS known_as, '*'::CHAR AS id, '*'::VARCHAR AS default_access
                            FROM account WHERE username = LOWER(uname);
                    END IF;
                END IF;
            ELSE
                RAISE EXCEPTION 'there is no such account!';
            END IF;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT * FROM get_other_account_data('ShayansHaFaGhi');

SELECT * FROM get_other_account_data('HosseinZaredar');

SELECT * FROM get_other_account_data('MatinTavakoli');

SELECT * FROM get_other_account_data('SajadSArlAkI');