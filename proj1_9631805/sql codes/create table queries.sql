CREATE TABLE account (
    username VARCHAR(20) PRIMARY KEY,
    hashed_password VARCHAR(40) NOT NULL,
    reg_date DATE NOT NULL,
    system_phone_number CHAR(12) NOT NULL,
    address VARCHAR(50) NOT NULL,
    firstname VARCHAR(20) NOT NULL,
    lastname VARCHAR(20) NOT NULL,
    personal_phone_number CHAR(13) NOT NULL,
    date_of_birth DATE NOT NULL,
    known_as VARCHAR(20) NOT NULL,
    id CHAR(10) NOT NULL,
    default_access VARCHAR(7) NOT NULL
);

CREATE TABLE notifications (
    username VARCHAR(20),
    message VARCHAR(100) NOT NULL,
    time TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES account(username)
);

CREATE TABLE access_table (
    administrating_user VARCHAR(20),
    accesed_user VARCHAR(20) NOT NULL,
    access_mode VARCHAR(7) NOT NULL,
    time TIMESTAMP NOT NULL,
    FOREIGN KEY (administrating_user) REFERENCES account(username)
);

CREATE TABLE time_table (
    username VARCHAR(20),
    time TIMESTAMP NOT NULL,
    FOREIGN KEY (username) REFERENCES account(username)
);

CREATE TABLE email (
    id SERIAL NOT NULL,
    subject VARCHAR(20) NOT NULL,
    time TIMESTAMP NOT NULL,
    message VARCHAR(200) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE email_sender (
    id INTEGER NOT NULL,
    sender_email VARCHAR(31) NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    PRIMARY KEY (id, sender_email),
    FOREIGN KEY (id) REFERENCES email(id)
);

CREATE TABLE email_recipient_list (
    id INTEGER NOT NULL,
    recipient_email VARCHAR(31) NOT NULL,
    sender_email VARCHAR(31) NOT NULL,
    is_read BOOLEAN NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    FOREIGN KEY (id, sender_email) REFERENCES email_sender(id, sender_email)
);

CREATE TABLE email_cc_recipient_list (
    id INTEGER NOT NULL,
    cc_recipient_email VARCHAR(31) NOT NULL,
    sender_email VARCHAR(31) NOT NULL,
    is_read BOOLEAN NOT NULL,
    is_deleted BOOLEAN NOT NULL,
    FOREIGN KEY (id, sender_email) REFERENCES email_sender(id, sender_email)
);