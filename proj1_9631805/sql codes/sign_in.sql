CREATE FUNCTION sign_in
    (IN uname VARCHAR,
    IN password VARCHAR,
    OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF ((SELECT username FROM account WHERE username = LOWER(uname) AND hashed_password = MD5(password)) IS NOT NULL) THEN
            IF LOWER(uname) <> signed_in_username THEN
                INSERT INTO time_table VALUES(LOWER(uname), (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                SELECT 'sign in successful!' INTO res;
            ELSE
                RAISE EXCEPTION 'you are already signed in!';
            END IF;
        ELSE
            RAISE EXCEPTION 'invalid. please try again!';
        END IF;
    END
    $$
LANGUAGE plpgsql;

SELECT sign_in(
    'mAtInTavakoLi',
    '7SA56AS45');

SELECT sign_in(
    'HosseinZaredar',
    '3AS46TH75');

SELECT sign_in(
    'ShayanShafaghi',
    '5YU42CX88');

SELECT sign_in(
    'SajadSarlaki',
    '7TU33HK21')