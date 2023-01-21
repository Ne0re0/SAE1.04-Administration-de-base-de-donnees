# Administration de base de données

Dans ce projet, nous devions montrer nos compétences dans le langage SQL (MySQL / MariaDB).

## Partie 1 : Traduction d'un schéma relationnel en script de création de tables  

Dans cette première partie, il nous a été donné un shéma relationnel (cf. schema relationnel (fourni))  
Il nous a été demandé d'écrire le script de création de table lui correspondant.  
Certaines altérations nous ont été demandé après la création des tables.

## Partie 2 : Test des contraintes 

Dans cette deuxième partie, nous devions notamment tester les contraintes d'existence et d'unicité des clés primaires ainsi que les contraintes de référencement des clées étrangères. A cela s'ajoutait d'autres contraintes externes.

## Partie 3 : Requêtage
Pour cette dernière partie, nous avions carte blanche sur les sujets des requêtes mais nous devions respecter une certaine quantité  
***Exemple :*** 2 projections avec restriction

En ce qui concerne les jointures, il nous avait été explicitement demandé de les écrire de la manière suivante :  
```sql
SELECT *
FROM Table1, Table2
WHERE condition de jointure;
```
C'est pourquoi, nous ne nous sommes par servi de JOIN ON et des différentes variantes pour les jointures.

***Auteurs :***
Bouillis Awen et moi-même
