create function sign_up(uname character varying, password character varying, system_phone_number character, address character varying, firstname character varying, lastname character varying, personal_phone_number character, date_of_birth date, known_as character varying, id character, default_access character varying, OUT res character varying) returns character varying
    language plpgsql
as
$$
BEGIN
        IF LENGTH(uname) >= 6 THEN
            IF LENGTH(password) >= 6 THEN
                IF ((SELECT username FROM account WHERE LOWER(uname) = LOWER(username)) IS NULL) THEN
                    INSERT INTO account VALUES (
                    uname,
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
                    INSERT INTO time_table VALUES(uname, (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
                    INSERT INTO notifications VALUES((NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP, 'Welcome to the foofle email system!', uname);
                    SELECT 'all good!' INTO res;
                ELSE
                    SELECT 'sorry! this username is occupied' INTO res;
                END IF;
            ELSE
                SELECT 'password is too short. try again!' INTO res;
            END IF;
        ELSE
            SELECT 'username is too short. try again!' INTO res;
        END IF;
    END
$$;

alter function sign_up(varchar, varchar, char, varchar, varchar, varchar, char, date, varchar, char, varchar, out varchar) owner to postgres;

