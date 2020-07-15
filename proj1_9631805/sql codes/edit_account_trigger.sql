CREATE OR REPLACE FUNCTION edit_account_trigger() RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO notifications VALUES(new.username, 'You have edited your account!', (NOW() + 4.5 * INTERVAL '1 hour')::TIMESTAMP);
        RETURN NULL;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER edit_account_trigger AFTER UPDATE ON account FOR EACH ROW
    EXECUTE FUNCTION edit_account_trigger();