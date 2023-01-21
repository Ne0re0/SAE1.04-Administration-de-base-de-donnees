----------------------------------------------------------------------
--        Tache 3 : Requêtes avec algèbre relationnel               --
----------------------------------------------------------------------
---------------------------------
-- Projection avec restriction --
---------------------------------
-- Quels sont les noms et prénoms des élève qui ont strictement plus de 18 ans ?
-- Algèbre relationnel : Eleve{age > 18}[nom, prenom]
SELECT DISTINCT nom, prenom
FROM Eleve
WHERE age > 18;


---------------------------------
-- Projection avec restriction --
---------------------------------
-- Quels sont les numéro des établissements privés ?
-- Algèbre relationnel : Etablissement{estPrive = 1}[numEtablissement]
SELECT numEtablissement
FROM Etablissement
WHERE estPrive = 1;


-----------
-- Union --
-----------
-- Quels sont les filières qui ont reçu un voeu et/ou ont fait l'objet d'une proposition ?
-- Algèbre relationnel : Voeu[uneFiliereVoeu] ? Proposition[uneFiliereP]
SELECT DISTINCT uneFiliereVoeu
FROM Voeu
UNION
SELECT DISTINCT uneFiliereP
FROM Proposition;


------------------
-- Intersection --
------------------
-- Quels sont les filières qui ont reçu au moins un voeu et ont fait l'object d'au moins une proposition ? 
-- Algèbre relationnel : Voeu[uneFiliereVoeu] ? Proposition[uneFiliereP]
SELECT DISTINCT uneFiliereVoeu
FROM Voeu
INTERSECT
SELECT DISTINCT uneFiliereP
FROM Proposition;


----------------------------
-- Différence ensembliste --
----------------------------
-- Quels sont les éleves qui n'ont pas fait de vœux ?
-- Algèbre relationnel : Eleve[numeroINE] \ Voeu[unEleve]
SELECT DISTINCT numeroINE
FROM Eleve
MINUS
SELECT DISTINCT unEleve
FROM Voeu;


--------------------------
-- Tri avec restriction --
--------------------------
-- Quels sont les noms des élèves qui dont le prénom commence par 'J' triés par ordre croissant de l'âge
-- Algèbre relationnel : Eleve{prenom LIKE 'J%'}(age >)[nom]
SELECT nom
FROM Eleve
WHERE UPPER(prenom) LIKE 'J%' ORDER BY age;


-----------------------------------------
-- Tri multi-attribut avec restriction --
-----------------------------------------
-- Quels sont les noms et prénoms des élèves de la filière générale triés par ordre croissant du nom et ordre croissant du prenom
-- Algèbre relationnel : Eleve{filiere = generale}[nom,prenom](nom > et prenom >)
SELECT nom, prenom
FROM Eleve
WHERE UPPER(voie) = 'GENERALE'
ORDER BY nom,prenom;


-------------------------
-- Tri avec limitation --
-------------------------
-- Quels sont les 10 premiers noms et prénoms des élèves triés par ordre alphabétique du nom
-- Algèbre relationnel : Eleve(nom >){ROWNUM < 10}[nom, prenom]
SELECT nom, prenom
FROM (SELECT * 
	FROM Eleve
	ORDER BY nom, prenom)
WHERE ROWNUM < 10;


-----------------------------
-- Jointure de deux tables --
-----------------------------
-- Pour chaque voeu, donner le nom et le prénom de l'élève qui a fait le voeux ainsi que le numéro de l'établissement concerné.
-- Algèbre relationnel : Voeu[[Voeu.unEleve = Eleve.numeroINE]]Eleve[nom,prenom,numEtablissement]
SELECT DISTINCT nom, prenom, unEtablissementVoeu
FROM Voeu, Eleve
WHERE Voeu.unEleve = Eleve.numeroINE;


-----------------------------
-- Jointure de deux tables --
-----------------------------
-- Quels sont les ages des élèves qui ont fait au moins un voeu
-- Voeu[[Voeu.unEleve = Eleve.numeroINE]]Eleve[age]
SELECT DISTINCT age
FROM Voeu, Eleve
WHERE Voeu.unEleve = Eleve.numeroINE;


------------------------------
-- Jointure de trois tables --
------------------------------
-- Quelles sont les filières qui ont reçues une proposition ?
-- Proposition[[proposition.uneMention, Proposition.uneFiliere = Mention.intituleMention, Mention.uneFiliere]]Mention[[Mention.uneFiliere = Filiere.nomFiliere]]Filiere[nomFiliere,estSelective]
SELECT nomFiliere, estSelective
FROM Proposition, Mention, Filiere
WHERE Proposition.uneMentionP = Mention.intituleMention 
	AND Proposition.uneFiliereP = Mention.uneFiliere 
	AND Mention.uneFiliere = Filiere.nomFiliere;


------------------
-- AutoJointure --
------------------
-- Quels sont les INE des élèves qui ont fait au moins 2 voeux
-- Voeu v1[[ v1.unEleve = v2.unEleve et (v1.uneMentionVoeux != v2.unMentionVoeux ou v1.unEtablissementVoeux != v2.unEtablissementVoeux) ]]v2 Voeu
SELECT DISTINCT v1.unEleve
FROM Voeu v1, Voeu v2
WHERE v1.unEleve = v2.unEleve 
	AND (v1.uneMentionVoeu != v2.uneMentionVoeu OR v1.unEtablissementVoeu != v2.unEtablissementVoeu);
