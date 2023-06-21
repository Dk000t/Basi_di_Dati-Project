CREATE TABLE UTENTE (
    Username VARCHAR2(20) PRIMARY KEY,
    Email VARCHAR2(30) UNIQUE NOT NULL,
    Data_Iscrizione DATE NOT NULL
);

CREATE TABLE COMMUNITY (
    Nome_Community VARCHAR2(30) PRIMARY KEY,
    Nome_Creatore VARCHAR2(20) UNIQUE NOT NULL,
    Data_Creazione DATE NOT NULL,
    CONSTRAINT FK_Community_Owner FOREIGN KEY (Nome_Creatore) REFERENCES UTENTE(Username)
);

CREATE TABLE POST (
    Nome_Community VARCHAR2(20),
    Codice_Post NUMBER NOT NULL,
    Titolo_Post VARCHAR2(200) NOT NULL,
    Creatore_Post VARCHAR2(20) UNIQUE NOT NULL,
    Data_Pubblicazione DATE NOT NULL,
    PRIMARY KEY(Nome_Community, Codice_Post),
    CONSTRAINT FK_Community_Name FOREIGN KEY (Nome_Community) REFERENCES COMMUNITY(Nome_Community),
    CONSTRAINT FK_Post_Owner FOREIGN KEY(Creatore_Post) REFERENCES UTENTE(Username)
);

CREATE TABLE GRUPPO (
    Nome_Gruppo VARCHAR2(20) PRIMARY KEY,
    Proprietario_Gruppo VARCHAR2(20) UNIQUE NOT NULL,
    Data_Creazione DATE NOT NULL,
    CONSTRAINT FK_Group_Owner FOREIGN KEY(Proprietario_Gruppo) REFERENCES UTENTE(Username)
);

CREATE TABLE E_AMICO_DI (
    Username_1 VARCHAR2(20),
    Username_2 VARCHAR2(20),
    Data_Inizio DATE NOT NULL,
    PRIMARY KEY(Username_1, Username_2),
    CONSTRAINT PK_User_1 FOREIGN KEY (Username_1) REFERENCES UTENTE(Username) ON DELETE CASCADE,
    CONSTRAINT PK_User_2 FOREIGN KEY (Username_2) REFERENCES UTENTE(Username) ON DELETE CASCADE,
);

CREATE TABLE SEGUE (
    Username VARCHAR2(20),
    Nome_Community VARCHAR2(20),
    Data_Iscrizione DATE NOT NULL,
    PRIMARY KEY(Username, Nome_Community),
    CONSTRAINT PK_User_Community FOREIGN KEY (Username) REFERENCES UTENTE(Username) ON DELETE CASCADE,
    CONSTRAINT PK_Community_Followed FOREIGN KEY (Nome_Community) REFERENCES COMMUNITY(Nome_Community) ON DELETE CASCADE,
);

CREATE TABLE FA_PARTE (
    Username VARCHAR2(20),
    Nome_Gruppo VARCHAR2(20),
    Data_Adesione DATE NOT NULL,
    PRIMARY KEY(Username, Nome_Gruppo),
    CONSTRAINT PK_User_Group FOREIGN KEY (Username) REFERENCES UTENTE(Username) ON DELETE CASCADE,
    CONSTRAINT PK_Group_Joined FOREIGN KEY (Nome_Gruppo) REFERENCES GRUPPO(Nome_Gruppo) ON DELETE CASCADE,
);

CREATE TABLE LISTA_DESIDERI (
    Username VARCHAR2(20),
    Nome_Gioco VARCHAR2(50) NOT NULL,
    Data_Inserimento DATE NOT NULL,
    PRIMARY KEY (Username, Nome_Lista),
    CONSTRAINT PK_List_Owner FOREIGN KEY (Username) REFERENCES UTENTE(Username) ON DELETE CASCADE,
    CONSTRAINT FK_Game_Name FOREIGN KEY (Nome_Gioco) REFERENCES GIOCO(Nome_Gioco) ON DELETE CASCADE,
);



