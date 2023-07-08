-- Creazione dell'Admin.
CREATE USER admin IDENTIFIED BY password;
-- Creazione dell'Editore.
CREATE USER editore IDENTIFIED BY password;
-- Creazione dello Sviluppatore.
CREATE USER sviluppatore IDENTIFIED BY password;
-- Creazione dell'Utente.
CREATE USER utente IDENTIFIED BY password;

--Privilegi sistema admin.
GRANT CREATE SESSION TO admin;
--Privilegi sistema editore.
GRANT CREATE SESSION TO editore;
--Privilegi sistema sviluppatore.
GRANT CREATE SESSION TO sviluppatore;

--Privilegi sistema admin.
GRANT CONNECT, CREATE SESSION TO admin;
--Privilegi sistema editore.
GRANT CONNECT, CREATE SESSION TO editore;
--Privilegi sistema sviluppatore.
GRANT CONNECT, CREATE SESSION TO sviluppatore;
--Privilegi sistema utente.
GRANT CONNECT, CREATE SESSION TO utente;

--Privilegi admin.
GRANT EXECUTE ON aggiungi_amico TO admin;
GRANT EXECUTE ON rimuovi_amico TO admin;
GRANT EXECUTE ON crea_community TO admin;
GRANT EXECUTE ON elimina_community TO admin;
GRANT EXECUTE ON modifica_stato_community TO admin;
GRANT EXECUTE ON segue_community TO admin;
GRANT EXECUTE ON crea_post TO admin;
GRANT EXECUTE ON elimina_post TO admin;
GRANT EXECUTE ON modifica_stato_post TO admin;
GRANT EXECUTE ON ins_recensione TO admin;
GRANT EXECUTE ON del_recensione TO admin;
GRANT EXECUTE ON ins_gioco_lista TO admin;
GRANT EXECUTE ON del_gioco_lista TO admin;
GRANT EXECUTE ON crea_gruppo TO admin;
GRANT EXECUTE ON elimina_gruppo TO admin;
GRANT EXECUTE ON follow_community TO admin;
GRANT EXECUTE ON unfollow_community TO admin;
GRANT EXECUTE ON ins_gioco TO admin;
GRANT EXECUTE ON del_gioco TO admin;
GRANT EXECUTE ON prezzo_gioco TO admin;
GRANT EXECUTE ON ins_dlc TO admin;
GRANT EXECUTE ON del_dlc TO admin;
GRANT EXECUTE ON prezzo_dlc TO admin;
GRANT EXECUTE ON ins_aggiornamento TO admin;
GRANT EXECUTE ON del_aggiornamento TO admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON UTENTE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON COMMUNITY TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON POST TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON GRUPPO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON E_AMICO_DI TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON SEGUE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON FA_PARTE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON CASA_SVILUPPATRICE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON EDITORE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON GIOCO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON DLC TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON AGGIORNAMENTO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON LISTA_DESIDERI TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON AGGIUNGE_GIOCO_LISTA TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON COLLEZIONABILE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON OTTIENE_COLLEZIONABILE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON OBIETTIVO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON RAGGIUNGE_OBIETTIVO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON RECENSIONE TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON PAGAMENTO TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON RISCATTA_DLC TO admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON RISCATTA_GIOCO TO admin;

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
