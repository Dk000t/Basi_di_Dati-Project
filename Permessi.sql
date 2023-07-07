--Privilegi sistema utente.
GRANT CONNECT, CREATE SESSION TO utente;
--Privilegi utente.
GRANT EXECUTE ON aggiungi_amico.proc TO utente;
GRANT EXECUTE ON rimuovi_amico.proc TO utente;
GRANT EXECUTE ON crea_community.proc TO utente;
GRANT EXECUTE ON elimina_community.proc TO utente;
GRANT EXECUTE ON modifica_stato_community.proc TO utente;
GRANT EXECUTE ON segue_community.proc TO utente;
GRANT EXECUTE ON crea_post.proc TO utente;
GRANT EXECUTE ON elimina_post.proc TO utente;
GRANT EXECUTE ON modifica_stato_post.proc TO utente;
GRANT EXECUTE ON ins_recensione.proc TO utente;
GRANT EXECUTE ON del_recensione.proc TO utente;
GRANT EXECUTE ON ins_gioco_lista.proc TO utente;
GRANT EXECUTE ON del_gioco_lista.proc TO utente;
GRANT EXECUTE ON crea_gruppo.proc TO utente;
GRANT EXECUTE ON elimina_gruppo.proc TO utente;
GRANT EXECUTE ON follow_community.proc TO utente;
GRANT EXECUTE ON unfollow_community.proc TO utente;
--Privilegi editore.
GRANT EXECUTE ON ins_gioco.proc TO editore;
GRANT EXECUTE ON del_gioco.proc TO editore;
GRANT EXECUTE ON prezzo_gioco.proc TO editore;
GRANT EXECUTE ON ins_dlc.proc TO editore;
GRANT EXECUTE ON del_dlc.proc TO editore;
GRANT EXECUTE ON prezzo_dlc.proc TO editore;
--Privilegi sviluppatore.
GRANT EXECUTE ON ins_aggiornamento.proc TO sviluppatore;
GRANT EXECUTE ON del_aggiornamento.proc TO sviluppatore;











