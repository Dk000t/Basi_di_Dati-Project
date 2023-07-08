-- Creazione dell'Admin.
CREATE USER admin_user IDENTIFIED BY password;
CREATE ROLE admin;
GRANT admin to admin_user
-- Creazione dell'Editore.
CREATE USER editore_user IDENTIFIED BY password;
CREATE ROLE editore;
GRANT editore to editore_user
-- Creazione dello Sviluppatore.
CREATE USER sviluppatore_user IDENTIFIED BY password;
CREATE ROLE sviluppatore;
GRANT sviluppatore to sviluppatore_user
-- Creazione dell'Utente.
CREATE USER standard_user IDENTIFIED BY password;
CREATE ROLE utente;
GRANT utente to standard_user

--Privilegi sistema admin.
GRANT CONNECT, CREATE SESSION TO admin;
--Privilegi sistema editore.
GRANT CONNECT, CREATE SESSION TO editore;
--Privilegi sistema sviluppatore.
GRANT CONNECT, CREATE SESSION TO sviluppatore;
--Privilegi sistema utente.
GRANT CONNECT, CREATE SESSION TO utente;

--Privilegi admin.
GRANT ALL PRIVILEGES TO admin;

--Privilegi utente.
GRANT EXECUTE ON aggiungi_amico TO utente;
GRANT EXECUTE ON rimuovi_amico TO utente;
GRANT EXECUTE ON crea_community TO utente;
GRANT EXECUTE ON elimina_community TO utente;
GRANT EXECUTE ON modifica_stato_community TO utente;
GRANT EXECUTE ON segue_community TO utente;
GRANT EXECUTE ON crea_post TO utente;
GRANT EXECUTE ON elimina_post TO utente;
GRANT EXECUTE ON modifica_stato_post TO utente;
GRANT EXECUTE ON ins_recensione TO utente;
GRANT EXECUTE ON del_recensione TO utente;
GRANT EXECUTE ON ins_gioco_lista TO utente;
GRANT EXECUTE ON del_gioco_lista TO utente;
GRANT EXECUTE ON crea_gruppo TO utente;
GRANT EXECUTE ON elimina_gruppo TO utente;
GRANT EXECUTE ON follow_community TO utente;
GRANT EXECUTE ON unfollow_community TO utente;

GRANT SELECT ON UTENTE TO utente;
GRANT SELECT ON COMMUNITY TO utente;
GRANT SELECT ON POST TO utente;
GRANT SELECT ON GRUPPO TO utente;
GRANT SELECT ON E_AMICO_DI TO utente;
GRANT SELECT ON SEGUE TO utente;
GRANT SELECT ON FA_PARTE TO utente;
GRANT SELECT ON CASA_SVILUPPATRICE TO utente;
GRANT SELECT ON EDITORE TO utente;
GRANT SELECT ON GIOCO TO utente;
GRANT SELECT ON DLC TO utente;
GRANT SELECT ON RECENSIONE TO utente;
GRANT SELECT ON OBIETTIVO TO utente;
GRANT SELECT ON COLLEZIONABILE TO utente;

--Privilegi editore.
GRANT EXECUTE ON ins_gioco TO editore;
GRANT EXECUTE ON del_gioco TO editore;
GRANT EXECUTE ON prezzo_gioco TO editore;
GRANT EXECUTE ON ins_dlc TO editore;
GRANT EXECUTE ON del_dlc TO editore;
GRANT EXECUTE ON prezzo_dlc TO editore;

GRANT SELECT ON GIOCO to editore;
GRANT SELECT ON DLC to editore;

--Privilegi sviluppatore.
GRANT EXECUTE ON ins_aggiornamento TO sviluppatore;
GRANT EXECUTE ON del_aggiornamento TO sviluppatore;


GRANT SELECT ON GIOCO to sviluppatore;
GRANT SELECT ON DLC to sviluppatore;
