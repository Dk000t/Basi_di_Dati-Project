-- L'utente si puo' disiscriversi dalla piattaforma solo il giorno dopo in cui si e' iscritto.
CREATE OR REPLACE TRIGGER TRG_ELIMINAZIONE_UTENTE
BEFORE DELETE ON UTENTE
FOR EACH ROW
DECLARE
    v_DataIscrizione UTENTE.DATA_ISCRIZIONE%TYPE;
    v_DataEliminazione UTENTE.DATA_ISCRIZIONE%TYPE;
BEGIN
    SELECT DATA_ISCRIZIONE, DATA_ISCRIZIONE + INTERVAL '1' DAY
    INTO v_DataIscrizione, v_DataEliminazione
    FROM UTENTE
    WHERE USERNAME = :OLD.USERNAME;

    IF TRUNC(SYSDATE) <= TRUNC(v_DataEliminazione) THEN
        RAISE_APPLICATION_ERROR(-20001, 'L''utente può essere eliminato solo dopo 24 ore dalla data di iscrizione.');
    END IF;
END;
