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

-- INSERIMENTO DEI DATI.

-- UTENTE
INSERT INTO UTENTE (Username, Email, Data_Iscrizione) VALUES 
    ('Alice123', 'alice@outlook.com', TO_DATE('10-03-2022', 'DD-MM-YYYY')), --post
    ('Bob456', 'bob@outlook.com', TO_DATE('15-09-2021', 'DD-MM-YYYY')), --post
    ('Charlie789', 'charlie@outlook.com', TO_DATE('05-01-2023', 'DD-MM-YYYY')), --post
    ('David321', 'david@outlook.com', TO_DATE('12-04-2015', 'DD-MM-YYYY')), --COMMUNITY --gruppo 
    ('Eva654', 'eva@outlook.com', TO_DATE('02-05-2023', 'DD-MM-YYYY')), --post
    ('Frank987', 'frank@outlook.com', TO_DATE('18-07-2022', 'DD-MM-YYYY')), --post
    ('Grace234', 'grace@outlook.com', TO_DATE('29-12-2021', 'DD-MM-YYYY')), --post
    ('Henry567', 'henry@outlook.com', TO_DATE('15-04-2010', 'DD-MM-YYYY')), --COMMUNITY
    ('Isabella890', 'isabella@outlook.com', TO_DATE('15-01-2016', 'DD-MM-YYYY')),--COMMUNITY
    ('Jack123', 'jack@outlook.com', TO_DATE('05-07-2010', 'DD-MM-YYYY')), --COMMUNITY X2 --gruppo
    ('Karen456', 'karen@outlook.com', TO_DATE('10-02-2023', 'DD-MM-YYYY')), --post --gruppo
    ('Leo789', 'leo@outlook.com', TO_DATE('15-10-2022', 'DD-MM-YYYY')), --post
    ('Mia321', 'mia@outlook.com', TO_DATE('20-04-2017', 'DD-MM-YYYY')), --COMMUNITY
    ('Nathan654', 'nathan@outlook.com', TO_DATE('02-06-2022', 'DD-MM-YYYY')), --post x2
    ('Olivia987', 'olivia@outlook.com', TO_DATE('18-12-2013', 'DD-MM-YYYY')), --COMMUNITY
    ('Peter123', 'peter@outlook.com', TO_DATE('07-08-2020', 'DD-MM-YYYY')), --gruppo
    ('Sarah456', 'sarah@outlook.com', TO_DATE('25-11-2013', 'DD-MM-YYYY')), --gruppo
    ('Tom789', 'tom@outlook.com', TO_DATE('16-09-2018', 'DD-MM-YYYY')), --post --gruppo
    ('Emma123', 'emma@outlook.com', TO_DATE('11-05-2020', 'DD-MM-YYYY')), --gruppo
    ('John456', 'john@outlook.com', TO_DATE('17-05-2018', 'DD-MM-YYYY')), --COMMUNITY
    ('Linda789', 'linda@outlook.com', TO_DATE('22-10-2022', 'DD-MM-YYYY')), --gruppo
    ('Michael321', 'michael@outlook.com', TO_DATE('05-06-2021', 'DD-MM-YYYY')); --post

-- COMMUNITY
INSERT INTO COMMUNITY (Nome_Community, Nome_Creatore, Data_Creazione) VALUES 
    ('Battlefield 2042', 'David321', TO_DATE('06-10-2021', 'DD-MM-YYYY')),
    ('Overclocking', 'Henry567', TO_DATE('10-02-2013', 'DD-MM-YYYY')),
    ('PC Masterrace', 'Isabella890', TO_DATE('18-01-2016', 'DD-MM-YYYY')),
    ('Nvidia', 'Jack123', TO_DATE('07-07-2010', 'DD-MM-YYYY')),
    ('Linux Gaming', 'Jack123', TO_DATE('06-10-2011', 'DD-MM-YYYY')),
    ('Italy Informatica', 'Mia321', TO_DATE('04-09-2019', 'DD-MM-YYYY')),
    ('Monster Hunter', 'Olivia987', TO_DATE('20-12-2013', 'DD-MM-YYYY')),
    ('Meme Hunter', 'John456', TO_DATE('24-06-2018', 'DD-MM-YYYY'));


-- POST
INSERT INTO POST (Nome_Community, Codice_Post, Titolo_Post, Creatore_Post, Data_Pubblicazione) 
VALUES
    ('Linux Gaming', '0000001', 'Just bought Nvidia RTX 3060 (12GB). Here''s how it fares on Linux...', 'Nathan654', TO_DATE('01-01-2012', 'DD-MM-YYYY')),
    ('Linux Gaming', '0000002', 'Diablo IV Black Screen', 'Leo789', TO_DATE('02-01-2013', 'DD-MM-YYYY')),
    ('Linux Gaming', '0000003', 'Apex Legends doesn t need DXVK cache files anymore to prevent stuttering', 'Karen456', TO_DATE('03-03-2012', 'DD-MM-YYYY')),
    ('Linux Gaming', '0000004', 'Fedora 39 To Raise It s vm.max_map_count To Satisfy Some Steam Play Games', 'Grace234', TO_DATE('30-12-2011', 'DD-MM-YYYY')),

    ('Monster Hunter', '0000001', 'Do you think the next MH is going to have crossplay or is just a "i hope so"?', 'Nathan654', TO_DATE('05-07-2014', 'DD-MM-YYYY')),
    ('Monster Hunter', '0000002', 'Looking for fellow hunters?', 'Frank987', TO_DATE('01-01-2015', 'DD-MM-YYYY')),

    ('Battlefield 2042', '0000001', 'DOES ANYONE KNOW WHY I CAN’T GET PAST THE LOAD SCREEN?!', 'Eva654', TO_DATE('07-10-2021', 'DD-MM-YYYY')),

    ('Overclocking', '0000001', 'For B-Die sake.', 'Charlie789', TO_DATE('03-03-2013', 'DD-MM-YYYY')),

    ('Nvidia', '0000001', 'Created a list with supported games for Nvidia Resizable Bar (532.03), just FYI.', 'Bob456', TO_DATE('04-01-2023', 'DD-MM-YYYY')),

    ('Italy Informatica', '0000001', 'Impatto delle AI generative sul lavoro autonomo', 'Alice123', TO_DATE('05-01-2020', 'DD-MM-YYYY')),

    ('PC Masterrace', '0000001', 'Got a Cablemod cable for my controller. Matches my case pretty nicely.', 'Tom789', TO_DATE('05-01-2017', 'DD-MM-YYYY')),
    ('PC Masterrace', '0000002', '7700x 6800xt Build', 'Michael1321', TO_DATE('04-06-2017', 'DD-MM-YYYY'));

--GRUPPO
INSERT INTO GRUPPO (Nome_Gruppo, Proprietario_Gruppo, Data_Creazione)
VALUES 
    ('SilverArrows', 'Linda789', TO_DATE('01-06-2023', 'DD-MM-YYYY')),
    ('CrimsonRiders', 'Emma123', TO_DATE('20-05-2023', 'DD-MM-YYYY')),
    ('SerenitySquad', 'Sarah456', TO_DATE('10-05-2014', 'DD-MM-YYYY')),
    ('ShadowLegends', 'Peter123', TO_DATE('03-06-2021', 'DD-MM-YYYY')),
    ('RadiantRiders', 'David321', TO_DATE('01-06-2017', 'DD-MM-YYYY')),
    ('PhoenixRebels', 'Tom789', TO_DATE('20-05-2020', 'DD-MM-YYYY')),
    ('EmeraldEnigma', 'Tom789', TO_DATE('10-05-2022', 'DD-MM-YYYY')),
    ('EtherealEssence', 'Karen456', TO_DATE('29-11-2023', 'DD-MM-YYYY'));

--AMICO_DI
INSERT INTO E_AMICO_DI (Username_1, Username_2, Data_Inizio) 
VALUES
    ('Alice123', 'Bob456', TO_DATE('01-07-2022', 'DD-MM-YYYY')),
    ('Alice123', 'Charlie789', TO_DATE('02-09-2023', 'DD-MM-YYYY')),
    ('Bob456', 'David321', TO_DATE('03-12-2021', 'DD-MM-YYYY')),
    ('Charlie789', 'Eva654', TO_DATE('04-08-2023', 'DD-MM-YYYY')),
    ('Charlie789', 'Frank987', TO_DATE('05-02-2023', 'DD-MM-YYYY')),
    ('David321', 'Isabella890', TO_DATE('06-01-2017', 'DD-MM-YYYY')),
    ('Eva654', 'Jack123', TO_DATE('07-06-2023', 'DD-MM-YYYY')),
    ('Frank987', 'Karen456', TO_DATE('08-05-2023', 'DD-MM-YYYY')),
    ('Grace234', 'Leo789', TO_DATE('09-11-2021', 'DD-MM-YYYY')),
    ('Henry567', 'Mia321', TO_DATE('10-01-2019', 'DD-MM-YYYY'));

--SEGUE
INSERT INTO SEGUE (Username, Nome_Community, Data_Iscrizione)
VALUES 
--Proprietari della community
    ('David321', 'Battlefield 2042', TO_DATE('06-10-2021', 'DD-MM-YYYY')),
    ('Henry567', 'Overclocking', TO_DATE('10-02-2013', 'DD-MM-YYYY'))
    ('Isabella890', 'PC Masterrace', TO_DATE('18-01-2016', 'DD-MM-YYYY')),
    ('Jack123', 'Nvidia', TO_DATE('07-07-2010', 'DD-MM-YYYY')),
    ('Jack123', 'Linux Gaming', TO_DATE('06-10-2011', 'DD-MM-YYYY')),
    ('Mia321', 'Italy Informatica', TO_DATE('04-09-2019', 'DD-MM-YYYY')),
    ('Olivia987', 'Monster Hunter', TO_DATE('20-12-2013', 'DD-MM-YYYY')),
    ('John456', 'Meme Hunter', TO_DATE('24-06-2018', 'DD-MM-YYYY')),
--Follower
    ('Alice123', 'Monster Hunter', TO_DATE('15-02-2023', 'DD-MM-YYYY')),
    ('Bob456', 'Linux Gaming', TO_DATE('10-05-2022', 'DD-MM-YYYY')),
    ('Charlie789', 'Overclocking', TO_DATE('20-03-2023', 'DD-MM-YYYY')),
    ('David321', 'Meme Hunter', TO_DATE('25-07-2015', 'DD-MM-YYYY')),
    ('Eva654', 'PC Masterrace', TO_DATE('12-06-2023', 'DD-MM-YYYY')),
    ('Frank987', 'Battlefield 2042', TO_DATE('25-10-2022', 'DD-MM-YYYY')),
    ('Karen456', 'Linux Gaming', TO_DATE('14-06-2023', 'DD-MM-YYYY')),
    ('Leo789', 'PC Masterrace', TO_DATE('01-04-2023', 'DD-MM-YYYY')),
    ('Mia321', 'Battlefield 2042', TO_DATE('27-05-2018', 'DD-MM-YYYY')),
    ('Nathan654', 'Overclocking', TO_DATE('03-07-2022', 'DD-MM-YYYY')),
    ('Olivia987', 'Italy Informatica', TO_DATE('09-03-2014', 'DD-MM-YYYY')),),
    ('John456', 'Overclocking', TO_DATE('24-04-2019', 'DD-MM-YYYY')),
    ('Linda789', 'Battlefield 2042', TO_DATE('19-03-2023', 'DD-MM-YYYY')),
    ('Michael321', 'Italy Informatica', TO_DATE('15-05-2022', 'DD-MM-YYYY'));



--FA_PARTE
INSERT INTO FA_PARTE (Username, Nome_Gruppo, Data_Adesione)
VALUES
--Proprietari Gruppo
   ('Linda789', 'SilverArrows', TO_DATE('01-06-2023', 'DD-MM-YYYY')),
   ('Emma123', 'CrimsonRiders', TO_DATE('20-05-2023', 'DD-MM-YYYY')),
   ('Sarah456', 'SerenitySquad', TO_DATE('10-05-2014', 'DD-MM-YYYY')),
   ('Peter123', 'ShadowLegends', TO_DATE('03-06-2021', 'DD-MM-YYYY')),
   ('David321', 'RadiantRiders', TO_DATE('01-06-2017', 'DD-MM-YYYY')),
   ('Tom789', 'PhoenixRebels', TO_DATE('20-05-2020', 'DD-MM-YYYY')),
   ('Tom789', 'EmeraldEnigma', TO_DATE('10-05-2022', 'DD-MM-YYYY')),
   ('Karen456', 'EtherealEssence', TO_DATE('29-11-2023', 'DD-MM-YYYY')),
--Partecipanti
   ('Isabella890', 'CrimsonRiders', TO_DATE('18-03-2017', 'DD-MM-YYYY')),
   ('Jack123', 'RadiantRiders', TO_DATE('08-08-2010', 'DD-MM-YYYY')),
   ('Karen456', 'ShadowLegends', TO_DATE('14-03-2023', 'DD-MM-YYYY')),
   ('Leo789', 'SerenitySquad', TO_DATE('01-04-2023', 'DD-MM-YYYY')),
   ('Mia321', 'SilverArrows', TO_DATE('27-05-2018', 'DD-MM-YYYY')),
   ('Nathan654', 'PhoenixRebels', TO_DATE('03-07-2023', 'DD-MM-YYYY')),
   ('Olivia987', 'PhoenixRebels', TO_DATE('09-03-2014', 'DD-MM-YYYY')),
   ('Peter123', 'PhoenixRebels', TO_DATE('05-04-2021', 'DD-MM-YYYY')),
   ('Sarah456', 'PhoenixRebels', TO_DATE('17-06-2014', 'DD-MM-YYYY')),
   ('Tom789', 'SilverArrows', TO_DATE('11-05-2019', 'DD-MM-YYYY')),
   ('Emma123', 'EmeraldEnigma', TO_DATE('29-06-2021', 'DD-MM-YYYY')),
   ('John456', 'EtherealEssence', TO_DATE('24-04-2019', 'DD-MM-YYYY')),
   ('Linda789', 'CrimsonRiders', TO_DATE('19-03-2023', 'DD-MM-YYYY')),
   ('Michael321', 'CrimsonRiders', TO_DATE('15-05-2023', 'DD-MM-YYYY'));

INSERT INTO LISTA_DESIDERI (Username, Nome_Gioco, Data_Inserimento)
VALUES
    ('Alice123', 'OVERWATCH 2', TO_DATE('15-04-2022', 'DD-MM-YYYY')),
    ('Bob456', 'YAKUZA', TO_DATE('23-10-2022', 'DD-MM-YYYY')),
    ('Charlie789', 'STARDEW VALLEY', TO_DATE('05-02-2023', 'DD-MM-YYYY')),
    ('David321', 'ANTHEM', TO_DATE('18-06-2015', 'DD-MM-YYYY')),
    ('Eva654', 'THE WITCHER 3', TO_DATE('16-10-2023', 'DD-MM-YYYY')),
    ('Frank987', 'MINECRAFT', TO_DATE('01-01-2023', 'DD-MM-YYYY')),
    ('Grace234', 'RED DEAD REDEMPTION', TO_DATE('30-12-2021', 'DD-MM-YYYY')),
    ('Henry567', 'IRON HARVEST', TO_DATE('12-06-2011', 'DD-MM-YYYY')),
    ('Isabella890', 'HORIZON ZERO DAWN', TO_DATE('07-03-2016', 'DD-MM-YYYY')),
    ('Jack123', 'HOUSE FLIPPER', TO_DATE('11-08-2010', 'DD-MM-YYYY')),
    ('Jack123', 'BORDERLANDS', TO_DATE('29-07-2010', 'DD-MM-YYYY')),
    ('Karen456', 'THE LEGEND OF ZELDA', TO_DATE('30-02-2023', 'DD-MM-YYYY')),
    ('Leo789', 'UNCHARTED', TO_DATE('18-11-2022', 'DD-MM-YYYY')),
    ('Mia321', 'CALL OF DUTY', TO_DATE('27-05-2017', 'DD-MM-YYYY')),
    ('Nathan654', 'BIOSHOCK', TO_DATE('09-12-2022', 'DD-MM-YYYY')),
    ('Nathan654', 'OVERWATCH 2', TO_DATE('14-11-2022', 'DD-MM-YYYY')),
    ('Olivia987', 'YAKUZA', TO_DATE('23-10-2015', 'DD-MM-YYYY')),
    ('Peter123', 'STARDEW VALLEY', TO_DATE('02-01-2021', 'DD-MM-YYYY')),
    ('Sarah456', 'ANTHEM', TO_DATE('22-04-2015', 'DD-MM-YYYY')),
    ('Tom789', 'THE WITCHER 3', TO_DATE('13-03-2019', 'DD-MM-YYYY')),
    ('Tom789', 'CALL OF DUTY', TO_DATE('07-02-2019', 'DD-MM-YYYY')),
    ('Emma123', 'UNCHARTED', TO_DATE('16-04-2021', 'DD-MM-YYYY')),
    ('John456', 'THE LEGEND OF ZELDA', TO_DATE('17-06-2018', 'DD-MM-YYYY')),
    ('Linda789', 'BORDERLANDS', TO_DATE('22-11-2022', 'DD-MM-YYYY')),
    ('Michael321', 'HORIZON ZERO DAWN', TO_DATE('05-09-2021', 'DD-MM-YYYY'));

...
