CREATE USER c##client_user IDENTIFIED BY Utente;
CREATE USER c##editore IDENTIFIED BY Editore;
CREATE USER c##client_admin IDENTIFIED BY Admin;
CREATE USER c##creatore_comm IDENTIFIED BY Creatore_Community;

GRANT ALL PRIVILEGES TO c##client_admin;
