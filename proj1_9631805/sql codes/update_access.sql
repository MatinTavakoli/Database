CREATE FUNCTION update_access(IN uname VARCHAR, IN mode VARCHAR, OUT res VARCHAR)
AS
    $$
    DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF (SELECT username FROM account WHERE username = LOWER(uname)) IS NOT NULL THEN
                IF LOWER(uname) = signed_in_username THEN
                    RAISE EXCEPTION 'this is yourself!';
                ELSE
                    IF (SELECT administrating_user FROM access_table WHERE administrating_user = signed_in_username AND accesed_user = LOWER(uname)) IS NOT NULL THEN
                        IF (SELECT access_mode FROM access_table WHERE administrating_user = signed_in_username AND accesed_user = LOWER(uname)) <> mode THEN
                            UPDATE access_table SET access_mode = mode, time = (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP WHERE administrating_user = signed_in_username AND accesed_user = LOWER(uname);
                            SELECT 'access updated!' INTO res;
                        ELSE
                            RAISE EXCEPTION 'current access already exists!';
                        END IF;
                    ELSE
                        INSERT INTO access_table VALUES(signed_in_username, LOWER(uname), mode, (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                        SELECT 'access added!' INTO res;
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



SELECT update_access('Hosseinzaredar', 'granted');

SELECT update_access('MatiNtaVaKoLi', 'denied');

SELECT update_access('saJaDSaRLaki', 'granted');