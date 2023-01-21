----------------------------------------------------------------------
--          Tache 1 : Creation et modification de tables            --
----------------------------------------------------------------------

------------------------------------
-- Partie 1 : Creation des tables --
------------------------------------

/* 
 * 
 * Remarque: pour dÃ©clarer les attributs de type Boolean, on utilise
 * le type NUMBER avec une vÃ©rification de valeur (0 ou 1)
 *
 */

------------------------------------
-- Suppression des cas d'erreurs  --
------------------------------------
DROP TABLE Proposition;
DROP TABLE Voeu;
DROP TABLE Etablissement;
DROP TABLE Eleve;
DROP TABLE Mention;
DROP TABLE Filiere;

-------------
-- FILIERE --
-------------
CREATE TABLE Filiere(
    nomFiliere VARCHAR2(30)
        CONSTRAINT pk_filiere PRIMARY KEY,
    estSelective NUMBER
	CONSTRAINT ck_estSelective CHECK (estSelective = 0 OR estSelective = 1) 
        CONSTRAINT nn_estSelective NOT NULL
);


-------------
-- Mention --
-------------
CREATE TABLE Mention(
    intituleMention VARCHAR(30),
    uneFiliere VARCHAR(30)
        CONSTRAINT fk_Mention_Filiere REFERENCES Filiere,
    CONSTRAINT pk_Mention PRIMARY KEY (intituleMention,uneFiliere)
);


-----------
-- Eleve --
-----------
CREATE TABLE Eleve(
    numeroINE VARCHAR2(30)
        CONSTRAINT pk_Eleve PRIMARY KEY,
    nom VARCHAR2(30)
        CONSTRAINT nn_nom NOT NULL,
    prenom VARCHAR2(30)
        CONSTRAINT nn_prenom NOT NULL,
    age NUMBER
        CONSTRAINT ck_age CHECK (age >= 0),
    estBoursier NUMBER
        CONSTRAINT ck_estBoursier CHECK (estBoursier = 0 OR estBoursier = 1),
    voie VARCHAR2(30)
        CONSTRAINT ck_voie CHECK (UPPER(voie) = 'GENERALE' OR UPPER(voie) = 'TECHNOLOGIQUE' OR UPPER(voie) = 'PROFESSIONNELLE'),
    CONSTRAINT uq_nom_prenom UNIQUE(nom,prenom)
);

-------------------
-- Etablissement --
------------------
CREATE TABLE Etablissement(
    numEtablissement NUMBER
        CONSTRAINT pk_Etablissement PRIMARY KEY, 
    estPrive NUMBER
        CONSTRAINT ck_estPrive CHECK (estPrive = 0 OR estPrive = 1)
);

----------
-- Voeu --
----------
CREATE TABLE Voeu(
    numeroVoeu NUMBER
        CONSTRAINT pk_voeu PRIMARY KEY,
    resultat VARCHAR2(30)
        CONSTRAINT ck_resultat CHECK (UPPER(resultat) = 'NON CLASSE' OR UPPER(resultat) = 'CLASSE NON APPELE' OR UPPER(resultat) = 'CLASSE APPELE')
        CONSTRAINT nn_resultat NOT NULL,
    dateAppel DATE,
    dateAcceptation DATE,
    unEleve VARCHAR(30)
        CONSTRAINT nn_unEleve NOT NULL
        CONSTRAINT fk_Voeu_Eleve REFERENCES Eleve,
    unEtablissementVoeu NUMBER
        CONSTRAINT fk_Voeu_Etablissement REFERENCES Etablissement
        CONSTRAINT nn_unEtablissementVoeu NOT NULL,
    uneMentionVoeu VARCHAR(30)
        CONSTRAINT nn_uneMentionVoeu NOT NULL,
    uneFiliereVoeu VARCHAR(30)
        CONSTRAINT nn_uneFiliereVoeu NOT NULL,
    CONSTRAINT fk_Voeu_Mention FOREIGN KEY(uneMentionVoeu, uneFiliereVoeu) REFERENCES Mention(intituleMention, uneFiliere)
);

CREATE TABLE Proposition(
    unEtablissementP NUMBER
       	CONSTRAINT fk_Proposition_Etalissement REFERENCES Etablissement,
    uneMentionP VARCHAR2(30),
    uneFiliereP VARCHAR2(30),
    CONSTRAINT fk_Proposition_Mention FOREIGN KEY(uneMentionP,uneFiliereP) REFERENCES Mention(intituleMention, uneFiliere),
    CONSTRAINT pk_Proposition PRIMARY KEY(unEtablissementP,uneMentionP,uneFiliereP)
);


---------------------------------------------
-- Partie 2 : AltÃ©ration des tables crÃ©Ã©es --
---------------------------------------------


-------------------------------------------------------------
-- 1) Ajout de la colonne moyenneGenerale Ã  la table Eleve --
-------------------------------------------------------------
ALTER TABLE Eleve 
	ADD moyenneGenerale NUMBER;
	
	
-------------------------------------------------------
-- 2) Suppression de la colonne prÃ©cÃ©demment ajoutÃ©e --
-------------------------------------------------------
ALTER TABLE Eleve 
	DROP COLUMN moyenneGenerale;
	
	
-----------------------------------------------------------------------------
-- 3) Ajout de la contraint DATEAppel < DATEAcceptation dans la table Voeu --
-----------------------------------------------------------------------------
ALTER TABLE Voeu 
	ADD CONSTRAINT ck_dateAppel_dateAcceptation CHECK (dateAppel < DATEAcceptation);
	
	
---------------------------------------------------------
-- 4) Supression de la contrainte prÃ©cÃ©demment ajoutÃ©e --
---------------------------------------------------------
ALTER TABLE Voeu 
	DROP CONSTRAINT ck_dateAppel_dateAcceptation;
