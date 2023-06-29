--Controllo se l'eta' e' maggiore uguale di 14.
CREATE OR REPLACE TRIGGER controllo_eta_utente
BEFORE INSERT ON UTENTE
FOR EACH ROW
DECLARE
    anni NUMBER;
BEGIN
    -- Calcola l'età dell'utente confrontando la data di nascita con la data corrente
    anni := TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.DATA_NASCITA) / 12);
    
    -- Se l'utente ha meno di 14 anni, solleva un'eccezione
    IF anni < 14 THEN
        RAISE_APPLICATION_ERROR(-20001, 'L''utente deve avere almeno 14 anni.');
    END IF;
END;

--Controllo coerenza data creazione community / data iscrizione utente.
CREATE OR REPLACE TRIGGER controllo_data_creazione_community
BEFORE INSERT ON COMMUNITY
FOR EACH ROW
DECLARE
    data_iscrizione_utente DATE;
BEGIN
    -- Ottieni la data di iscrizione dell'utente
    SELECT DATA_ISCRIZIONE INTO data_iscrizione_utente
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    -- Verifica se la data di creazione della community è minore o uguale alla data di iscrizione dell'utente
    IF :NEW.DATA_CREAZIONE <= data_iscrizione_utente THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di creazione della community deve essere successiva alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo coerenza data pubblicazione post / data creazione community.
CREATE OR REPLACE TRIGGER CHECK_DATA_PUBBLICAZIONE
BEFORE INSERT ON POST
FOR EACH ROW
DECLARE
    v_data_creazione DATE;
BEGIN
    -- Recupera la data di creazione della community corrispondente
    SELECT DATA_CREAZIONE INTO v_data_creazione
    FROM COMMUNITY
    WHERE NOME_COMMUNITY = :NEW.NOME_COMMUNITY;
    
    -- Controlla se la data di pubblicazione è successiva alla data di creazione
    IF :NEW.DATA_PUBBLICAZIONE <= v_data_creazione THEN
        RAISE_APPLICATION_ERROR(-20002, 'La data di pubblicazione deve essere successiva alla data di creazione della community.');
    END IF;
END;

--Controllo coerenza data creazione gruppo / data iscrizione utente.
CREATE OR REPLACE TRIGGER CHECK_DATA_CREAZIONE
BEFORE INSERT ON GRUPPO
FOR EACH ROW
DECLARE
    v_data_iscrizione DATE;
BEGIN
    -- Recupera la data di iscrizione dell'utente corrispondente
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    -- Controlla se la data di creazione è successiva alla data di iscrizione
    IF :NEW.DATA_CREAZIONE <= v_data_iscrizione THEN
        RAISE_APPLICATION_ERROR(-20003, 'La data di creazione del gruppo deve essere successiva alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo coerenza data di amicizia / data iscrizione utente.
CREATE OR REPLACE TRIGGER CHECK_DATA_AMICIZIA
BEFORE INSERT ON E_AMICO_DI
FOR EACH ROW
DECLARE
    v_data_iscrizione_1 DATE;
    v_data_iscrizione_2 DATE;
BEGIN
    -- Recupera la data di iscrizione dell'utente USERNAME_1
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione_1
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME_1;

    -- Recupera la data di iscrizione dell'utente USERNAME_2
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione_2
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME_2;

    -- Controlla se la data di amicizia è successiva o uguale alle date di iscrizione
    IF :NEW.DATA_INIZIO < v_data_iscrizione_1 OR :NEW.DATA_INIZIO < v_data_iscrizione_2 THEN
        RAISE_APPLICATION_ERROR(-20004, 'La data di inizio amicizia deve essere successiva o uguale alle date di iscrizione degli utenti.');
    END IF;
END;

--Controllo ...data ...
CREATE OR REPLACE TRIGGER CHECK_DATA_SEGUE
BEFORE INSERT ON SEGUE
FOR EACH ROW
DECLARE
    v_data_iscrizione DATE;
BEGIN
    -- Recupera la data di iscrizione dell'utente corrispondente
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    -- Controlla se la data di segue è successiva o uguale alla data di iscrizione
    IF :NEW.DATA_ISCRIZIONE < v_data_iscrizione THEN
        RAISE_APPLICATION_ERROR(-20005, 'La data di segue deve essere successiva o uguale alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo ... data ...
CREATE OR REPLACE TRIGGER CHECK_DATA_ADESIONE
BEFORE INSERT ON FA_PARTE
FOR EACH ROW
DECLARE
    v_data_iscrizione DATE;
BEGIN
    -- Recupera la data di iscrizione dell'utente corrispondente
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    -- Controlla se la data di adesione è successiva o uguale alla data di iscrizione
    IF :NEW.DATA_ADESIONE < v_data_iscrizione THEN
        RAISE_APPLICATION_ERROR(-20006, 'La data di adesione deve essere successiva o uguale alla data di iscrizione dell''utente.');
    END IF;
END;

-- Controllo ... data ...
CREATE OR REPLACE TRIGGER CHECK_DATA_RILASCIO
BEFORE INSERT ON GIOCO
FOR EACH ROW
DECLARE
    v_data_fondazione_editore DATE;
    v_data_fondazione_sviluppatore DATE;
BEGIN
    -- Recupera la data di fondazione dell'editore corrispondente
    SELECT ANNO_FONDAZIONE_EDITORE INTO v_data_fondazione_editore
    FROM EDITORE
    WHERE NOME_EDITORE = :NEW.NOME_EDITORE;

    -- Recupera la data di fondazione dello sviluppatore corrispondente
    SELECT ANNO_FONDAZIONE_SVILUPPATORE INTO v_data_fondazione_sviluppatore
    FROM CASA_SVILUPPATRICE
    WHERE NOME_SVILUPPATORE = :NEW.NOME_SVILUPPATORE;

    -- Controlla se la data di rilascio è successiva alle date di fondazione
    IF :NEW.DATA_RILASCIO <= v_data_fondazione_editore OR :NEW.DATA_RILASCIO <= v_data_fondazione_sviluppatore THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di rilascio del gioco deve essere successiva alle date di fondazione dell''editore e dello sviluppatore.');
    END IF;
END;


--verificare che l'utente possa inserire solo una recensione
CREATE OR REPLACE TRIGGER checkLimitRecension
BEFORE INSERT ON RECENSIONE 
FOR EACH ROW
DECLARE
    rec_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO rec_count
    FROM RECENSIONE
    WHERE USERNAME = :NEW.USERNAME
    AND NOME_GIOCO = :NEW.NOME_GIOCO;

    IF rec_count = 1 THEN
       RAISE_APPLICATION_ERROR(-20008, 'Only one review can be submitted per game');
    END IF;
END;


--verificare che la data creazione di un post non sia inferiore alla data creazione della community
CREATE OR REPLACE TRIGGER checkPostDate
BEFORE INSERT ON POST
FOR EACH ROW
DECLARE
    wrongPostDate  EXCEPTION;
BEGIN
    IF :NEW.DATA.PUBBLICAZIONE < :NEW.DATA.CREAZIONE THEN --confronto tra post e community
        RAISE wrongPostDate;
    END IF;
EXCEPTION
    WHEN wrongPostDate THEN  
        RAISE_APPLICATION_ERROR(-20007, 'Post date error');
END;


--Trigger data creazione utente(non deve essere superiore della data attuale)
CREATE OR REPLACE TRIGGER checkDateUser
BEFORE INSERT ON UTENTE 
FOR EACH ROW 
DECLARE
    wrongDateUser   EXCEPTION;
BEGIN
    IF :NEW.DATA_ISCRIZIONE > SYSDATE THEN
        RAISE wrongDateUser;
    END IF;
EXCEPTION
    WHEN wrongDateUser THEN
        RAISE_APPLICATION_ERROR(-20000, 'La data non e''corretta');
END;



