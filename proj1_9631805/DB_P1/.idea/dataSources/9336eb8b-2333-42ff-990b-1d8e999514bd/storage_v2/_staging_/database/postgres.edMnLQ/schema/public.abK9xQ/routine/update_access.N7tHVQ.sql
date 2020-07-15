create function update_access(uname character varying, mode character varying, OUT res character varying) returns character varying
    language plpgsql
as
$$
DECLARE
        signed_in_username VARCHAR := (SELECT username FROM time_table ORDER BY time DESC FETCH FIRST ROW ONLY);
    BEGIN
        IF signed_in_username IS NOT NULL THEN
            IF (SELECT username FROM account WHERE username = LOWER(uname)) IS NOT NULL THEN
                IF LOWER(uname) = signed_in_username) THEN
                    SELECT 'this is yourself!' INTO res;
                ELSE
                    IF (SELECT administrating_user FROM access_table WHERE administrating_user = signed_in_username AND LOWER(accesed_user) = LOWER(uname)) IS NOT NULL THEN
                        IF (SELECT access_mode FROM access_table WHERE administrating_user = signed_in_username AND LOWER(accesed_user) = LOWER(uname)) <> mode THEN
                            UPDATE access_table SET access_mode = mode, time = (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP WHERE administrating_user = signed_in_username AND LOWER(accesed_user) = LOWER(uname);
                            SELECT 'access updated!' INTO res;
                        ELSE
                            SELECT 'current access already exists!' INTO res;
                        END IF;
                    ELSE
                        INSERT INTO access_table VALUES(signed_in_username, uname, mode, (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                        SELECT 'access added!' INTO res;
                    END IF;
                END IF;
            ELSE
                SELECT 'there is no such account!' INTO res;
            END IF;
        ELSE
            SELECT 'please sign up/in first!' INTO res;
        END IF;
    END
$$;

alter function update_access(varchar, varchar, out varchar) owner to postgres;

