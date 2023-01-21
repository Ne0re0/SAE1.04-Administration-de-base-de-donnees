----------------------------------------------------------------------
--                Tache 2 : Test des contraintes                    --
----------------------------------------------------------------------



---------------------------------------------------------------------------
-- Test de l'existence de la clé primaire nomFiliere de la table Filiere --
---------------------------------------------------------------------------
-- Une erreur d'existence doit apparaitre lors de l'insertion suivante car on insert NULL à l'emplacement de la clé primaire
INSERT INTO Filiere VALUES (NULL, 0);
/*
ORA-01400: cannot insert NULL into ("SQL_EWJRXPRFCGGGHGKKZYLKVFWSD"."FILIERE"."NOMFILIERE") ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



-------------------------------------------------------------------------
-- Test de l'existence de la clé primaire numeroINE de la table Eleve  --
-------------------------------------------------------------------------
-- Une erreur d'existence doit apparaitre lors de l'insertion suivante car on insert NULL à l'emplacement de la clé primaire
INSERT INTO Eleve VALUES (NULL, 'Müller', 'Thomas',17, 0, 'Technologique');
/*
ORA-01400: cannot insert NULL into ("SQL_EWJRXPRFCGGGHGKKZYLKVFWSD"."ELEVE"."NUMEROINE") ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



----------------------------------------------------------------------
-- Test de l'unicité de la clé primaire numeroVoeu de la table Voeu --
----------------------------------------------------------------------
-- Insertion des données nécessaires au test
INSERT INTO Filiere VALUES ('BUT',1);
INSERT INTO Mention VALUES ('Informatique', 'BUT' );
INSERT INTO Eleve VALUES ('1234567890G', 'Mbappe', 'Kylian', 24, 0, 'Technologique');
INSERT INTO Etablissement VALUES (4, 1);
-- Un erreur d'unicité est sensée se produire lors de la deuxième insertion car la clé primaire 1 existe déjà
INSERT INTO Voeu VALUES (1,'Non Classe', TO_DATE('2021/04/20', 'yyyy/mm/dd'), TO_DATE('2021/07/09', 'yyyy/mm/dd'), '1234567890G', 4, 'Informatique', 'BUT' );
INSERT INTO Voeu VALUES (1,'Classe appele', NULL, NULL, '1234567890G', 4, 'Informatique', 'BUT' );
/*
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
ORA-00001: unique constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.PK_VOEU) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



------------------------------------------------------------------------
-- Test d'unicité de la clé candidate (nom, prenom) de la table Eleve --
------------------------------------------------------------------------
-- Une erreur d'unicité est sensée se produire lors de la deuxième insertion car on insert une valeur identique
INSERT INTO Eleve VALUES ('1234567890E', 'Giroud', 'Olivier', 36, 0, 'Generale');
INSERT INTO Eleve VALUES ('1234567890F', 'Giroud', 'Olivier', 2, 0, 'Technologique');
/*
1 row(s) inserted.
ORA-00001: unique constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.UQ_NOM_PRENOM) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



----------------------------------------------------------------------------------------------------------------------
-- Test d'intégrité référentielle de la clé étrangère uneFiliere de la table Mention qui référence la table Filiere --
----------------------------------------------------------------------------------------------------------------------
-- Une erreur d'intégrité est sensée apparaitre lors de l'insertion suivante car la filière "License" n'est pas enregistrée
INSERT INTO Mention VALUES ('Informatique', 'Licence');
-- Une erreur d'intégrité est sensée apparaitre lors de la suppression de la filière car elle est référencée
-- Insertion des données nécessaires
INSERT INTO Filiere VALUES ('CPGE', 1);
INSERT INTO Mention VALUES ('Informatique', 'CPGE');
-- Erreur :
DELETE FROM Filiere WHERE nomFiliere = 'CPGE';
/*
ORA-02291: integrity constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.FK_MENTION_FILIERE) violated - parent key not found ORA-06512: at "SYS.DBMS_SQL", line 1721
1 row(s) inserted.
1 row(s) inserted.
ORA-02292: integrity constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.FK_MENTION_FILIERE) violated - child record found ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



--------------------------------------------------------------------------------------------------------------
-- Test d'intégrité référentielle de la clé étrangère unEleve de la table Voeu qui référence la table Eleve --
--------------------------------------------------------------------------------------------------------------
-- Une erreur d'intégrité est sensée se produire lors de la dernière insertion car le numeroINE n'est pas enregistré
-- Insertion des données nécessaires pour cibler l'erreur sur la clé étrangère
INSERT INTO Etablissement VALUES (5,0);
INSERT INTO Filiere VALUES ('Licence', 1);
INSERT INTO Mention VALUES ('Mathematiques', 'Licence');
-- Cas d'erreur
INSERT INTO Voeu VALUES (2,'Non classe', NULL, NULL, 'INE_inexistant', 5,'Mathematiques', 'Licence');
-- Une deuxieme erreur d'intégrité est sensée se produire pour la suppression du tuple Eleve car on supprime un tuple enregistré
-- Insertion des données 
INSERT INTO Eleve VALUES ('1010101010K', 'Leborgne', 'Néo', 18, 0, 'Generale');
INSERT INTO Voeu VALUES (2,'Non classe', NULL, NULL, '1010101010K', 5,'Mathematiques', 'Licence');
-- Suppression de la clé étrangère depuis la table de référence
DELETE FROM Eleve WHERE nom = 'Leborgne';
/*
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
ORA-02291: integrity constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.FK_VOEUX_ELEVE) violated - parent key not found ORA-06512: at "SYS.DBMS_SQL", line 1721
1 row(s) inserted.
1 row(s) inserted.
ORA-02292: integrity constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.FK_VOEUX_ELEVE) violated - child record found ORA-06512: at "SYS.DBMS_SQL", line 1721
*/



--------------------------------------------------------------------------
-- Test de la contrainte de valeur sur l'attribut age de la table Eleve --
--------------------------------------------------------------------------
--Une erreur est sensée se produire lors de la premiere insertion car age < 0 mais pas lors de la deuxième
INSERT INTO Eleve VALUES ('1010101010L', 'Bouillis', 'Awen', -19, 0, 'Generale');
INSERT INTO Eleve VALUES ('1010101010L', 'Bouillis', 'Awen', 19, 0, 'Generale');
/*
ORA-02290: check constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.CK_AGE) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
1 row(s) inserted.
*/



---------------------------------------------------------------------------
-- Test de la contrainte de domaine de l'attribut voie de la table Eleve --
---------------------------------------------------------------------------
-- Quatres erreurs sont sensées se produire car le domaine de voie est incorrect
INSERT INTO Eleve VALUES ('1010101010M', 'Jean', 'Jean', 19, 0, 'AutreVoie');
INSERT INTO Eleve VALUES ('1010101010N', 'Jules', 'Jules', 24, 0, 'SecondTest');
INSERT INTO Eleve VALUES ('1010101010O', 'Marc', 'Marc', 19, 0, 'DernierEssai');
INSERT INTO Eleve VALUES ('1010101010P', 'Veronique', 'Veronique', 19, 0, 'Générale');
-- Quatre insertions sont ensuite sensées avoir lieu sans erreur
INSERT INTO Eleve VALUES ('1010101010M', 'Jean', 'Jean', 19, 0, 'Generale');
INSERT INTO Eleve VALUES ('1010101010N', 'Jules', 'Jules', 24, 0, 'Technologique');
INSERT INTO Eleve VALUES ('1010101010O', 'Marc', 'Marc', 19, 0, 'Professionnelle');
INSERT INTO Eleve VALUES ('1010101010P', 'Veronique', 'Veronique', 19, 0, 'GeNeRaLe');
/*
ORA-02290: check constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.CK_VOIE) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
ORA-02290: check constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.CK_VOIE) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
ORA-02290: check constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.CK_VOIE) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
ORA-02290: check constraint (SQL_EWJRXPRFCGGGHGKKZYLKVFWSD.CK_VOIE) violated ORA-06512: at "SYS.DBMS_SQL", line 1721
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
1 row(s) inserted.
*/

/*
Remarque : 
Nous avons décider de ne pas valider les informations lorsque celles ci comportent des é car nous
avons établi que l'alphabet utilisé dans les bases de données est préférablement l'alphabet anglophone
En revanche, les majuscules ne gênent pas les insertions des données pour les faciliter
*/
