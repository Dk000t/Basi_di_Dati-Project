--Controllo se l'eta' e' maggiore uguale di 14. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_ISCRIZIONE
BEFORE INSERT ON UTENTE
FOR EACH ROW
DECLARE
    anni_diff NUMBER;
BEGIN
    anni_diff := EXTRACT(YEAR FROM :NEW.DATA_ISCRIZIONE) - EXTRACT(YEAR FROM :NEW.DATA_NASCITA);
    IF anni_diff < 14 THEN
        RAISE_APPLICATION_ERROR(-20001, 'L''utente deve avere almeno 14 anni per iscriversi.');
    END IF;
END;

--Controllo coerenza data creazione community / data iscrizione utente. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER controllo_data_creazione_community
BEFORE INSERT ON COMMUNITY
FOR EACH ROW
DECLARE
    data_iscrizione_utente DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO data_iscrizione_utente
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;
    IF :NEW.DATA_CREAZIONE < data_iscrizione_utente THEN
        RAISE_APPLICATION_ERROR(-20002, 'La data di creazione della community deve essere successiva alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo coerenza data pubblicazione post / data creazione community. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_PUBBLICAZIONE
BEFORE INSERT ON POST
FOR EACH ROW
DECLARE
    v_data_creazione DATE;
BEGIN
    SELECT DATA_CREAZIONE INTO v_data_creazione
    FROM COMMUNITY
    WHERE NOME_COMMUNITY = :NEW.NOME_COMMUNITY;
    
    IF :NEW.DATA_PUBBLICAZIONE < v_data_creazione THEN
        RAISE_APPLICATION_ERROR(-20003, 'La data di pubblicazione deve essere successiva alla data di creazione della community.');
    END IF;
END;

--Controllo coerenza data creazione gruppo / data iscrizione utente. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_CREAZIONE
BEFORE INSERT ON GRUPPO
FOR EACH ROW
DECLARE
    v_data_iscrizione DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    IF :NEW.DATA_CREAZIONE < v_data_iscrizione THEN
        RAISE_APPLICATION_ERROR(-20004, 'La data di creazione del gruppo deve essere successiva alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo che un utente non possa essere amico di se stesso. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_ISCRIZIONE
BEFORE INSERT ON UTENTE
FOR EACH ROW
DECLARE
    anni_diff NUMBER;
BEGIN
    anni_diff := EXTRACT(YEAR FROM :NEW.DATA_ISCRIZIONE) - EXTRACT(YEAR FROM :NEW.DATA_NASCITA);
    IF anni_diff < 14 THEN
        RAISE_APPLICATION_ERROR(-20005, 'L''utente deve avere almeno 14 anni per iscriversi.');
    END IF;
END;
/


--Controllo coerenza data di amicizia / data iscrizione utente. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_AMICIZIA
BEFORE INSERT ON E_AMICO_DI
FOR EACH ROW
DECLARE
    v_data_iscrizione_1 DATE;
    v_data_iscrizione_2 DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione_1
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME_1;

    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione_2
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME_2;

    IF :NEW.DATA_INIZIO < v_data_iscrizione_1 OR :NEW.DATA_INIZIO < v_data_iscrizione_2 THEN
        RAISE_APPLICATION_ERROR(-20006, 'La data di inizio amicizia deve essere successiva o uguale alle date di iscrizione degli utenti.');
    END IF;
END;

--Controllo duplicazione amicizia. (Se esiste l'associazione inversa) (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_AMICIZIA_DUPLICATA
BEFORE INSERT ON E_AMICO_DI
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM E_AMICO_DI
    WHERE USERNAME_1 = :NEW.USERNAME_2 AND USERNAME_2 = :NEW.USERNAME_1;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'La relazione di amicizia inversa esiste già.');
    END IF;
END;

--Controllo coerenza data segue ed iscrizione utente. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_DATA_SEGUE 
BEFORE INSERT ON SEGUE
FOR EACH ROW
DECLARE
    v_data_iscrizione DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    IF :NEW.DATA_ISCRIZIONE < v_data_iscrizione THEN
        RAISE_APPLICATION_ERROR(-20008, 'La data di segue deve essere successiva o uguale alla data di iscrizione dell''utente.');
    END IF;
END;

--Controllo coerenza data adesione gruppo e data iscrizione utente e data creazione gruppo. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER CHECK_ADESIONE_GRUPPO
BEFORE INSERT ON FA_PARTE
FOR EACH ROW
DECLARE
    v_data_iscrizione UTENTE.DATA_ISCRIZIONE%TYPE;
    v_data_creazione GRUPPO.DATA_CREAZIONE%TYPE;
BEGIN
    SELECT DATA_ISCRIZIONE
    INTO v_data_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_CREAZIONE
    INTO v_data_creazione
    FROM GRUPPO
    WHERE NOME_GRUPPO = :NEW.NOME_GRUPPO;

    IF :NEW.DATA_ADESIONE <= v_data_iscrizione OR :NEW.DATA_ADESIONE <= v_data_creazione THEN
        RAISE_APPLICATION_ERROR(-20009, 'La data di adesione al gruppo deve essere successiva sia alla data di iscrizione dell''utente che alla data di creazione del gruppo.');
    END IF;
END;

-- Controllo coerenza data pubblicazione gioco con editore e sviluppatore.  (NON FUNZIONA - DA MODIFICARE ANNO FONDAZIONE EDITORE E SVILUPPATORE CON DATA DD/MM/YY) 
CREATE OR REPLACE TRIGGER CHECK_DATA_RILASCIO
BEFORE INSERT ON GIOCO
FOR EACH ROW
DECLARE
    v_data_fondazione_editore DATE;
    v_data_fondazione_sviluppatore DATE;
BEGIN
    SELECT ANNO_FONDAZIONE_EDITORE INTO v_data_fondazione_editore
    FROM EDITORE
    WHERE NOME_EDITORE = :NEW.NOME_EDITORE;

    SELECT ANNO_FONDAZIONE_SVILUPPATORE INTO v_data_fondazione_sviluppatore
    FROM CASA_SVILUPPATRICE
    WHERE NOME_SVILUPPATORE = :NEW.NOME_SVILUPPATORE;

    IF :NEW.DATA_RILASCIO <= v_data_fondazione_editore OR :NEW.DATA_RILASCIO <= v_data_fondazione_sviluppatore THEN
        RAISE_APPLICATION_ERROR(-20010, 'La data di rilascio del gioco deve essere successiva alle date di fondazione dell''editore e dello sviluppatore.');
    END IF;
END;

--Controllo coerenza inserimento gioco in lista desideri controllando che sia maggiore alla data di iscrizione e alla data di rilascio di gioco.
CREATE OR REPLACE TRIGGER check_wishlist_insert
BEFORE INSERT ON LISTA_DESIDERI
FOR EACH ROW
DECLARE
    v_user_registration_date UTENTE.DATA_ISCRIZIONE%TYPE;
    v_game_release_date GIOCO.DATA_RILASCIO%TYPE;
BEGIN
    SELECT DATA_ISCRIZIONE
    INTO v_user_registration_date
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;
    SELECT DATA_RILASCIO
    INTO v_game_release_date
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;
    IF :NEW.DATA_INSERIMENTO < v_user_registration_date OR :NEW.DATA_INSERIMENTO < v_game_release_date THEN
        RAISE_APPLICATION_ERROR(-200011, 'La data di inserimento deve essere successiva alla data di iscrizione dell''utente e alla data di rilascio del gioco.');
    END IF;
END;

--Controllo coerenza data ottenimento collezionabile con data iscrizione utente e data pagamento gioco.
CREATE OR REPLACE TRIGGER check_data_ottenimento
BEFORE INSERT ON OTTIENE_COLLEZIONABILE
FOR EACH ROW
DECLARE
    utente_iscrizione DATE;
    pagamento_data DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO utente_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_PAGAMENTO INTO pagamento_data
    FROM PAGAMENTO
    WHERE CODICE_RICEVUTA_PAGAMENTO = :NEW.CODICE_RICEVUTA_PAGAMENTO;

    IF (:NEW.DATA_OTTENIMENTO_COLLEZIONABILE <= utente_iscrizione OR :NEW.DATA_OTTENIMENTO_COLLEZIONABILE <= pagamento_data) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di ottenimento del collezionabile deve essere successiva alla data di iscrizione dell''utente e alla data di pagamento.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
END;

--Controllo coerenza data raggiungimento obiettivo con data iscrizione utente e data pagamento gioco.
CREATE OR REPLACE TRIGGER check_data_ottenimento_obiettivo
BEFORE INSERT ON RAGGIUNGE_OBIETTIVO
FOR EACH ROW
DECLARE
    utente_iscrizione DATE;
    pagamento_data DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO utente_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_PAGAMENTO INTO pagamento_data
    FROM PAGAMENTO
    WHERE CODICE_RICEVUTA_PAGAMENTO = :NEW.CODICE_RICEVUTTO_OBIETTIVO;

    IF (:NEW.DATA_OTTENIMENTO_OBIETTIVO <= utente_iscrizione OR :NEW.DATA_OTTENIMENTO_OBIETTIVO <= pagamento_data) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di ottenimento dell''obiettivo deve essere successiva alla data di iscrizione dell''utente e alla data di pagamento.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
END;

--Controllo data recensione con data iscrizione utente e data acquisto gioco
CREATE OR REPLACE TRIGGER check_data_recensione
BEFORE INSERT ON RECENSIONE
FOR EACH ROW
DECLARE
    utente_iscrizione DATE;
    pagamento_data DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO utente_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_PAGAMENTO INTO pagamento_data
    FROM PAGAMENTO
    WHERE CODICE_RICEVUTA_PAGAMENTO = :NEW.CODICE_RICEVUTA_PAGAMENTO;

    IF (:NEW.DATA_RECENSIONE <= utente_iscrizione OR :NEW.DATA_RECENSIONE <= pagamento_data) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di recensione deve essere successiva alla data di iscrizione dell''utente e alla data di pagamento.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;

--Controllo data pagamento con data iscrizione utente e data rilascio gioco.
CREATE OR REPLACE TRIGGER check_data_pagamento
BEFORE INSERT ON PAGAMENTO
FOR EACH ROW
DECLARE
    utente_iscrizione DATE;
    gioco_data_rilascio DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO utente_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_RILASCIO INTO gioco_data_rilascio
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;

    IF (:NEW.DATA_PAGAMENTO <= utente_iscrizione OR :NEW.DATA_PAGAMENTO <= gioco_data_rilascio) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di pagamento deve essere successiva alla data di iscrizione dell''utente e alla data di rilascio del gioco.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;

--Controllo che data key_gioco sia maggiore di data iscrizione e data rilascio gioco
CREATE OR REPLACE TRIGGER check_data_scadenza
BEFORE INSERT ON KEY_GIOCO
FOR EACH ROW
DECLARE
    utente_iscrizione DATE;
    gioco_data_rilascio DATE;
BEGIN
    SELECT DATA_ISCRIZIONE INTO utente_iscrizione
    FROM UTENTE
    WHERE USERNAME = :NEW.USERNAME;

    SELECT DATA_RILASCIO INTO gioco_data_rilascio
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;

    IF (:NEW.DATA_SCADENZA <= utente_iscrizione OR :NEW.DATA_SCADENZA <= gioco_data_rilascio) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di scadenza della chiave deve essere successiva alla data di iscrizione dell''utente e alla data di rilascio del gioco.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
END;

--Controlla che data DLC sia dopo data_rilascio gioco
CREATE OR REPLACE TRIGGER check_data_rilascio_dlc
BEFORE INSERT ON DLC
FOR EACH ROW
DECLARE
    gioco_data_rilascio DATE;
BEGIN
    SELECT DATA_RILASCIO INTO gioco_data_rilascio
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;

    IF (:NEW.DATA_RILASCIO_DLC <= gioco_data_rilascio) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di rilascio del DLC deve essere successiva alla data di rilascio del gioco.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
END;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

--Trigger che verifica il numero massimo di community che l'utente puo' creare (essendo una relazione 1:N nell'E/R)
CREATE OR REPLACE TRIGGER check_community_limit
BEFORE INSERT ON COMMUNITY
FOR EACH ROW
DECLARE
    limite_community CONSTANT NUMBER := 5;
    numero_community NUMBER;
BEGIN
    SELECT COUNT(*) INTO numero_community
    FROM COMMUNITY
    WHERE USERNAME = :NEW.USERNAME;

    IF numero_community >= limite_community THEN
        RAISE_APPLICATION_ERROR(-20012, 'Hai raggiunto il numero massimo di community che puoi creare.');
    END IF;
END;



