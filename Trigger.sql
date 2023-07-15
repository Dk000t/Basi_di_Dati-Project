--CONTROLLA CHE IL VOTO DI UNA RECENSIONE SIA MIN 1 E MAX 10. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER controllo_voto_max
BEFORE INSERT OR UPDATE ON RECENSIONE
FOR EACH ROW
DECLARE
    voto_min CONSTANT NUMBER := 1;
    voto_max CONSTANT NUMBER := 10;
BEGIN
    IF :NEW.VOTO < voto_min OR :NEW.VOTO > voto_max THEN
        RAISE_APPLICATION_ERROR(-20001, 'Il voto deve essere compreso tra 1 e 10.');
    END IF;
END;
/
--Controlla che un utente possa seguire una community solo se il suo stato non e' 'Privata'. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER trg_segui_community
BEFORE INSERT ON SEGUE
FOR EACH ROW
DECLARE
  stato_community VARCHAR2(10);
BEGIN
  SELECT STATO_COMMUNITY INTO stato_community
  FROM COMMUNITY
  WHERE NOME_COMMUNITY = :NEW.NOME_COMMUNITY;
  
  IF stato_community != 'PUBBLICA' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Non è consentito seguire una community con stato diverso da "PUBBLICA".');
  END IF;
END;
/
--Trigger data creazione utente(non deve essere superiore della data attuale). (TESTATO FUNZIONA)
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
/
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
/
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
/
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
/
--Controllo coerenza data creazione gruppo / data iscrizione utente. (TESTATO FUNZIONA)
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

    IF v_data_iscrizione IS NOT NULL AND v_data_creazione IS NOT NULL THEN
        IF :NEW.DATA_ADESIONE < v_data_iscrizione OR :NEW.DATA_ADESIONE < v_data_creazione THEN
            RAISE_APPLICATION_ERROR(-20009, 'La data di adesione al gruppo deve essere successiva sia alla data di iscrizione dell''utente che alla data di creazione del gruppo.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20010, 'Utente o gruppo non esistente.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Utente o gruppo non esistente.');
END;
/
--Controllo che un utente non possa essere amico di se stesso. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER TRG_CONTROLLA_AMICIZIA
BEFORE INSERT OR UPDATE ON E_AMICO_DI
FOR EACH ROW 
BEGIN
    IF (:NEW.USERNAME_1 = :NEW.USERNAME_2) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Un utente non può essere amico di se stesso.');
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
/
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
/
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
/
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

    IF :NEW.DATA_ADESIONE < v_data_iscrizione OR :NEW.DATA_ADESIONE < v_data_creazione THEN
        RAISE_APPLICATION_ERROR(-20009, 'La data di adesione al gruppo deve essere successiva sia alla data di iscrizione dell''utente che alla data di creazione del gruppo.');
    END IF;
END;
/
-- Controllo coerenza data pubblicazione gioco con editore e sviluppatore. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER TRG_CONTROLLA_DATA_RILASCIO
BEFORE INSERT ON GIOCO
FOR EACH ROW
DECLARE
    v_data_sviluppatore DATE;
    v_data_editore DATE;
BEGIN
    SELECT DATA_FONDAZIONE_SVILUPPATORE INTO v_data_sviluppatore
    FROM CASA_SVILUPPATRICE
    WHERE NOME_SVILUPPATORE = :NEW.NOME_SVILUPPATORE;
    SELECT DATA_FONDAZIONE_EDITORE INTO v_data_editore
    FROM EDITORE
    WHERE NOME_EDITORE = :NEW.NOME_EDITORE;
    IF :NEW.DATA_RILASCIO < v_data_sviluppatore OR :NEW.DATA_RILASCIO < v_data_editore THEN
        RAISE_APPLICATION_ERROR(-20010, 'La data di rilascio deve essere successiva alla data di fondazione dello sviluppatore e dell''editore.');
    END IF;
END;
/
--Controllo coerenza inserimento gioco in lista desideri controllando che sia maggiore alla data di iscrizione e alla data di rilascio di gioco. (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER TRG_INSERIMENTO_GIOCO_LISTA
BEFORE INSERT ON AGGIUNGE_GIOCO_LISTA
FOR EACH ROW
DECLARE
    v_Data_Iscrizione UTENTE.DATA_ISCRIZIONE%TYPE;
    v_Data_Rilascio GIOCO.DATA_RILASCIO%TYPE;
BEGIN
    SELECT u.DATA_ISCRIZIONE
    INTO v_Data_Iscrizione
    FROM UTENTE u
    INNER JOIN LISTA_DESIDERI ld ON ld.USERNAME = u.USERNAME
    WHERE ld.ID_LISTA = :NEW.ID_LISTA;

    SELECT g.DATA_RILASCIO
    INTO v_Data_Rilascio
    FROM GIOCO g
    WHERE g.NOME_GIOCO = :NEW.NOME_GIOCO;

    IF :NEW.DATA_INSERIMENTO < v_Data_Iscrizione OR :NEW.DATA_INSERIMENTO < v_Data_Rilascio THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di inserimento deve essere successiva alla data di iscrizione dell''utente e alla data di rilascio del gioco.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'L''utente o il gioco associati non esistono.');
END;
/
--Controlla che data DLC sia dopo data_rilascio gioco (TESTATO FUNZIONANTE)
CREATE OR REPLACE TRIGGER check_data_rilascio_dlc
BEFORE INSERT ON DLC
FOR EACH ROW
DECLARE
    gioco_data_rilascio DATE;
BEGIN
    SELECT DATA_RILASCIO INTO gioco_data_rilascio
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;

    IF (:NEW.DATA_RILASCIO_DLC < gioco_data_rilascio) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di rilascio del DLC deve essere successiva alla data di rilascio del gioco.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
END;
/
--Controllo coerenza data rilascio aggiornamento con data rilascio gioco (TESTATO FUNZIONA)
CREATE OR REPLACE TRIGGER TRG_CONTROLLA_DATA_AGGIORNAMENTO
BEFORE INSERT ON AGGIORNAMENTO
FOR EACH ROW
DECLARE
    v_data_rilascio_gioco DATE;
BEGIN
    SELECT DATA_RILASCIO INTO v_data_rilascio_gioco
    FROM GIOCO
    WHERE NOME_GIOCO = :NEW.NOME_GIOCO;
    IF :NEW.DATA_RILASCIO < v_data_rilascio_gioco THEN
        RAISE_APPLICATION_ERROR(-20001, 'La data di aggiornamento deve essere successiva alla data di rilascio del gioco.');
    END IF;
END;
/
