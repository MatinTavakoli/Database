CREATE FUNCTION sign_up
    (IN uname VARCHAR,
    IN password VARCHAR,
    IN system_phone_number CHAR,
    IN address VARCHAR,
    IN firstname VARCHAR,
    IN lastname VARCHAR,
    IN personal_phone_number CHAR,
    IN date_of_birth DATE,
    IN known_as VARCHAR,
    IN id CHAR,
    IN default_access VARCHAR,
    OUT res VARCHAR)
AS
    $$
    BEGIN
        IF LENGTH(uname) >= 6 THEN
            IF LENGTH(password) >= 6 THEN
                IF ((SELECT username FROM account WHERE username = LOWER(uname)) IS NULL) THEN
                    INSERT INTO account VALUES (
                    LOWER(uname),
                    MD5(password),
                    NOW()::DATE,
                    system_phone_number,
                    address,
                    firstname,
                    lastname,
                    personal_phone_number,
                    date_of_birth,
                    known_as,
                    id,
                    default_access);
                    INSERT INTO time_table VALUES(LOWER(uname), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                    SELECT 'sign up successful!' INTO res;
                ELSE
                    RAISE EXCEPTION 'sorry! this username is occupied';
                END IF;
            ELSE
                RAISE EXCEPTION 'password is too short. try again!';
            END IF;
        ELSE
            RAISE EXCEPTION 'username is too short. try again!';
        END IF;
    END
    $$
LANGUAGE plpgsql;



SELECT sign_up(
    'MatinTavakoli',
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

SELECT sign_up(
    'HosseinZaredar',
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

SELECT sign_up(
    'ShayanShafaghi',
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

SELECT sign_up(
    'SajadSarlaki',
    '7TU33HK21',
    '+98219302399',
    'mamazan',
    'Sajad',
    'Sarlaki',
    '+989025171167',
    '1998-10-12',
    'sajad',
    '0923320993',
    'always');

SELECT sign_up(
    'deletedaccount',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    '0001-01-01',
        'unknown',
        'unknown',
        'unknown'
           )