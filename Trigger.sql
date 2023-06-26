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
/

