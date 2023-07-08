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
CREATE USER utente IDENTIFIED BY password;
CREATE ROLE standard_uuser;
GRANT user to standard_utente

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
--Privilegi editore.
GRANT EXECUTE ON ins_gioco TO editore;
GRANT EXECUTE ON del_gioco TO editore;
GRANT EXECUTE ON prezzo_gioco TO editore;
GRANT EXECUTE ON ins_dlc TO editore;
GRANT EXECUTE ON del_dlc TO editore;
GRANT EXECUTE ON prezzo_dlc TO editore;
--Privilegi sviluppatore.
GRANT EXECUTE ON ins_aggiornamento TO sviluppatore;
GRANT EXECUTE ON del_aggiornamento TO sviluppatore;
