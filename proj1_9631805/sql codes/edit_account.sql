CREATE FUNCTION edit_account
    (IN new_password VARCHAR,
    IN new_system_phone_number CHAR,
    IN new_address VARCHAR,
    IN new_firstname VARCHAR,
    IN new_lastname VARCHAR,
    IN new_personal_phone_number CHAR,
    IN new_date_of_birth DATE,
    IN new_known_as VARCHAR,
    IN new_id CHAR,
    IN new_default_access VARCHAR,
    OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF LENGTH(new_password) >= 6 THEN
                IF (SELECT username FROM account WHERE
                username = signed_in_username AND
                hashed_password = MD5(new_password) AND
                system_phone_number = new_system_phone_number AND
                address = new_address AND
                firstname = new_firstname AND
                lastname = new_lastname AND
                personal_phone_number = new_personal_phone_number AND
                date_of_birth = new_date_of_birth AND
                known_as = new_known_as AND
                id = new_id AND
                default_access = new_default_access) IS NULL THEN
                    UPDATE account SET
                    hashed_password = MD5(new_password),
                    system_phone_number = new_system_phone_number,
                    address = new_address,
                    firstname = new_firstname,
                    lastname = new_lastname,
                    personal_phone_number = new_personal_phone_number,
                    date_of_birth = new_date_of_birth,
                    known_as = new_known_as,
                    id = new_id,
                    default_access = new_default_access WHERE username = signed_in_username;
                    SELECT 'edit successful!' INTO res;
                ELSE
                    RAISE EXCEPTION 'there is nothing to change!';
                END IF;
            ELSE
                RAISE EXCEPTION 'password is too short. try again!';
            END IF;
        ELSE
            RAISE EXCEPTION 'please sign up/in first!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT edit_account(
    '7SA56AS45',
    '+98214273112',
    'chitgar',
    'Matin',
    'Tavakoli',
    '+989037203775',
    '1999-8-26',
    'matin',
    '0935847483',
    'always');

SELECT edit_account(
    '3AS46TH75',
    '+98217532423',
    'karaj',
    'Hossein',
    'Zaredar',
    '+989395124043',
    '1999-10-12',
    'hossein',
    '0963134653',
    'never');

SELECT edit_account(
    '5YU42CX88',
    '+98215461768',
    'shahran',
    'Shayan',
    'Shafaghi',
    '+989397304252',
    '1999-4-23',
    'shayan',
    '0975151940',
    'never');

SELECT edit_account(
    '7TU33HK21',
    '+98219302399',
    'mamazan',
    'Sajad',
    'Sarlaki',
    '+989025171167',
    '1998-10-13',
    'sajad',
    '0923320993',
    'always');