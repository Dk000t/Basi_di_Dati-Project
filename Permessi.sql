--Privilegi sistema utente.
GRANT CONNECT, CREATE SESSION TO utente;
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











