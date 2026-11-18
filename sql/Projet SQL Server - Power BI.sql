USE RH_Analytics;
GO

--création de la table Departements
CREATE TABLE Departements (
    id_departement INT PRIMARY KEY,
    nom_departement VARCHAR(100) NOT NULL,
    ville VARCHAR(50) NOT NULL,
    budget_annuel DECIMAL(12,2) NOT NULL
);
GO

--vérifier la structure
EXEC sp_help 'Departements';
GO

--importer le fichier département
BULK INSERT Departements
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\Departements.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

--Vérifier la table
SELECT *
FROM Departements;
GO

SELECT COUNT(*) AS Nombre_Departements
FROM Departements;
GO

--création de la table poste
USE RH_Analytics;
GO

CREATE TABLE Postes (
    id_poste INT PRIMARY KEY,
    titre_poste VARCHAR(100) NOT NULL,
    id_departement INT NOT NULL,
    niveau VARCHAR(50) NOT NULL,
    salaire_min DECIMAL(10,2) NOT NULL,
    salaire_max DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Postes_Departements
        FOREIGN KEY (id_departement)
        REFERENCES Departements(id_departement)
);
GO

--vérifier la structure
EXEC sp_help 'Postes';
GO

--importer le fichier CSV postes
BULK INSERT Postes
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\Postes.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);
GO

--vérifier que tout est correct
SELECT *
FROM Postes;
GO

SELECT COUNT(*) AS Nombre_Postes
FROM Postes;
GO

--création de la table Employes
CREATE TABLE Employes (
    id_employe INT PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    sexe VARCHAR(20),
    date_naissance DATE,
    date_embauche DATE NOT NULL,
    id_departement INT NOT NULL,
    id_poste INT NOT NULL,
    statut VARCHAR(50),
    date_depart DATE NULL,
    motif_depart VARCHAR(100) NULL,

    CONSTRAINT FK_Employes_Departements
        FOREIGN KEY (id_departement)
        REFERENCES Departements(id_departement),

    CONSTRAINT FK_Employes_Postes
        FOREIGN KEY (id_poste)
        REFERENCES Postes(id_poste)
);
GO

--création de la table Employes
DROP TABLE Employes;
GO

CREATE TABLE Employes (
    id_employe INT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    sexe VARCHAR(10),
    date_naissance DATE,
    date_embauche DATE NOT NULL,
    date_depart DATE NULL,
    id_poste INT NOT NULL,
    id_departement INT NOT NULL,
    salaire_actuel DECIMAL(10,2),
    statut VARCHAR(50),
    motif_depart VARCHAR(150) NULL,
    email VARCHAR(150),
    ville VARCHAR(100),
    mode_travail VARCHAR(50),

    CONSTRAINT FK_Employes_Postes
        FOREIGN KEY (id_poste)
        REFERENCES Postes(id_poste),

    CONSTRAINT FK_Employes_Departements
        FOREIGN KEY (id_departement)
        REFERENCES Departements(id_departement)
);
GO

--vérifier la structure de la table
EXEC sp_help 'Employes';
GO

--importer le fichier CSV Employes
BULK INSERT Employes
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\Employes.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

--vérifer que tout est correct
SELECT COUNT(*) AS Nombre_Employes
FROM Employes;
GO

--pour voir quelques lignes
SELECT TOP 10 *
FROM Employes;
GO

--création de la table HistoriqueSlaire
CREATE TABLE HistoriqueSalaire (
    id_historique INT PRIMARY KEY,
    id_employe INT NOT NULL,
    date_effet DATE NOT NULL,
    ancien_salaire DECIMAL(10,2),
    nouveau_salaire DECIMAL(10,2),
    motif VARCHAR(100),

    CONSTRAINT FK_HistoriqueSalaire_Employes
        FOREIGN KEY (id_employe)
        REFERENCES Employes(id_employe)
);
GO

--importer le fichier
BULK INSERT HistoriqueSalaire
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\HistoriqueSalaire.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

--vérifier la structure
SELECT TOP 10 *
FROM HistoriqueSalaire;
GO

SELECT COUNT(*) AS Nombre_HistoriqueSalaire
FROM HistoriqueSalaire;
GO

--création de la table Absences
CREATE TABLE Absences (
    id_absence INT PRIMARY KEY,
    id_employe INT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nb_jours INT NOT NULL,
    type_absence VARCHAR(100),

    CONSTRAINT FK_Absences_Employes
        FOREIGN KEY (id_employe)
        REFERENCES Employes(id_employe)
);
GO
 --vérifier la structure
 EXEC sp_help 'Absences';
GO

--importer le fichier
BULK INSERT Absences
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\Absences.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

--vérifier la table
SELECT TOP 10 *
FROM Absences;
GO

SELECT COUNT(*) AS Nombre_Absences
FROM Absences;
GO

--création de la table Evaluation
CREATE TABLE Evaluations (
    id_evaluation INT PRIMARY KEY,
    id_employe INT NOT NULL,
    date_evaluation DATE NOT NULL,
    note_performance DECIMAL(3,1),
    objectifs_atteints_pct INT,
    commentaire VARCHAR(255),

    CONSTRAINT FK_Evaluations_Employes
        FOREIGN KEY (id_employe)
        REFERENCES Employes(id_employe)
);
GO

--vérifer la structure
EXEC sp_help 'Evaluations';
GO

--imoporter le fichier
BULK INSERT Evaluations
FROM 'C:\Users\Lenovo\OneDrive\Desktop\Fichiers CSV\Evaluations.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

--vérifier
SELECT TOP 10 *
FROM Evaluations;
GO

SELECT COUNT(*) AS Nombre_Evaluations
FROM Evaluations;
GO

--contrôle qualité des données
--Doublons dans Departements
SELECT id_departement, COUNT(*) AS Nombre
FROM Departements
GROUP BY id_departement
HAVING COUNT(*) > 1;

--Doublons dans Postes
SELECT id_poste, COUNT(*) AS Nombre
FROM Postes
GROUP BY id_poste
HAVING COUNT(*) > 1;

--Doublons dans Employes
SELECT id_employe, COUNT(*) AS Nombre
FROM Employes
GROUP BY id_employe
HAVING COUNT(*) > 1;

--Doublons dans HistoriqueSalaire
SELECT id_historique, COUNT(*) AS Nombre
FROM HistoriqueSalaire
GROUP BY id_historique
HAVING COUNT(*) > 1;

--Doublons dans Absences
SELECT id_absence, COUNT(*) AS Nombre
FROM Absences
GROUP BY id_absence
HAVING COUNT(*) > 1;

--Doublons dans Evaluations
SELECT id_evaluation, COUNT(*) AS Nombre
FROM Evaluations
GROUP BY id_evaluation
HAVING COUNT(*) > 1;
GO

--contrôle des valeurs NULL, les données incohérentes
--Table Employes
SELECT
    COUNT(*) AS Total_Employes,

    SUM(CASE WHEN nom IS NULL THEN 1 ELSE 0 END) AS Null_Nom,

    SUM(CASE WHEN prenom IS NULL THEN 1 ELSE 0 END) AS Null_Prenom,

    SUM(CASE WHEN date_naissance IS NULL THEN 1 ELSE 0 END) AS Null_DateNaissance,

    SUM(CASE WHEN date_embauche IS NULL THEN 1 ELSE 0 END) AS Null_DateEmbauche,

    SUM(CASE WHEN id_poste IS NULL THEN 1 ELSE 0 END) AS Null_Poste,

    SUM(CASE WHEN id_departement IS NULL THEN 1 ELSE 0 END) AS Null_Departement,

    SUM(CASE WHEN salaire_actuel IS NULL THEN 1 ELSE 0 END) AS Null_Salaire,

    SUM(CASE WHEN statut IS NULL THEN 1 ELSE 0 END) AS Null_Statut,

    SUM(CASE WHEN date_depart IS NULL THEN 1 ELSE 0 END) AS Null_DateDepart,

    SUM(CASE WHEN motif_depart IS NULL THEN 1 ELSE 0 END) AS Null_MotifDepart

FROM Employes;
GO

--confirmation avec le statut employes
SELECT
    statut,
    COUNT(*) AS Nombre_Employes
FROM Employes
GROUP BY statut;
GO

--les employes qui ont quitté l'entreprise
SELECT
    COUNT(*) AS Employes_Avec_Date_Depart
FROM Employes
WHERE date_depart IS NOT NULL;
GO

--contrôles les salaire
SELECT
    MIN(salaire_actuel) AS Salaire_Minimum,
    MAX(salaire_actuel) AS Salaire_Maximum,
    AVG(salaire_actuel) AS Salaire_Moyen
FROM Employes;
GO

--salaire négatif
SELECT *
FROM Employes
WHERE salaire_actuel <= 0;
GO

--vérifier si le salaire actuel de chaque employé respecte la fourchette salariale prévue pour son poste.
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    p.titre_poste,
    e.salaire_actuel,
    p.salaire_min,
    p.salaire_max
FROM Employes e
INNER JOIN Postes p
    ON e.id_poste = p.id_poste
WHERE e.salaire_actuel < p.salaire_min
   OR e.salaire_actuel > p.salaire_max;
GO

--vérifier si ces écarts sont seulement au-dessus du maximum ou s’il existe aussi des salaires sous le minimum
SELECT
    CASE
        WHEN e.salaire_actuel < p.salaire_min THEN 'Sous le minimum'
        WHEN e.salaire_actuel > p.salaire_max THEN 'Au-dessus du maximum'
    END AS Type_Ecart,
    COUNT(*) AS Nombre_Employes
FROM Employes e
INNER JOIN Postes p
    ON e.id_poste = p.id_poste
WHERE e.salaire_actuel < p.salaire_min
   OR e.salaire_actuel > p.salaire_max
GROUP BY
    CASE
        WHEN e.salaire_actuel < p.salaire_min THEN 'Sous le minimum'
        WHEN e.salaire_actuel > p.salaire_max THEN 'Au-dessus du maximum'
    END;
GO

--contrôle des dates
SELECT
    SUM(
        CASE
            WHEN date_naissance >= date_embauche
            THEN 1 ELSE 0
        END
    ) AS Naissance_Apres_Embauche,

    SUM(
        CASE
            WHEN date_depart IS NOT NULL
             AND date_depart < date_embauche
            THEN 1 ELSE 0
        END
    ) AS Depart_Avant_Embauche,

    SUM(
        CASE
            WHEN date_embauche > GETDATE()
            THEN 1 ELSE 0
        END
    ) AS Embauche_Dans_Futur

FROM Employes;
GO

--vérifier l'âge moyen d'embauche
SELECT
    id_employe,
    nom,
    prenom,
    date_naissance,
    date_embauche,
    DATEDIFF(YEAR, date_naissance, date_embauche) AS Age_Embauche
FROM Employes
WHERE DATEDIFF(YEAR, date_naissance, date_embauche) < 18;
GO

--
SELECT
    id_employe,
    nom,
    prenom,
    date_naissance,
    date_embauche,

    DATEDIFF(YEAR, date_naissance, date_embauche)
    -
    CASE
        WHEN DATEADD(
            YEAR,
            DATEDIFF(YEAR, date_naissance, date_embauche),
            date_naissance
        ) > date_embauche
        THEN 1
        ELSE 0
    END AS Age_Exact_Embauche

FROM Employes
WHERE
    DATEDIFF(YEAR, date_naissance, date_embauche)
    -
    CASE
        WHEN DATEADD(
            YEAR,
            DATEDIFF(YEAR, date_naissance, date_embauche),
            date_naissance
        ) > date_embauche
        THEN 1
        ELSE 0
    END < 18;
GO

--contrôle des Absences
SELECT
    SUM(
        CASE
            WHEN date_fin < date_debut
            THEN 1 ELSE 0
        END
    ) AS Fin_Avant_Debut,

    SUM(
        CASE
            WHEN nb_jours <= 0
            THEN 1 ELSE 0
        END
    ) AS Nb_Jours_Invalide,

    SUM(
        CASE
            WHEN nb_jours > DATEDIFF(DAY, date_debut, date_fin) + 1
            THEN 1 ELSE 0
        END
    ) AS Duree_Incoherente

FROM Absences;
GO

-- contrôle de la table Evaluation
SELECT
    MIN(note_performance) AS Note_Minimum,
    MAX(note_performance) AS Note_Maximum,
    AVG(note_performance) AS Note_Moyenne,

    MIN(objectifs_atteints_pct) AS Objectif_Minimum,
    MAX(objectifs_atteints_pct) AS Objectif_Maximum,
    AVG(CAST(objectifs_atteints_pct AS DECIMAL(10,2))) AS Objectif_Moyen

FROM Evaluations;
GO

--rechercher les valeurs potentiellement invalides
SELECT *
FROM Evaluations
WHERE note_performance < 0
   OR note_performance > 5
   OR objectifs_atteints_pct < 0
   OR objectifs_atteints_pct > 100;
GO

--contrôle de la table HistoriqueSalaire
SELECT
    SUM(CASE 
        WHEN ancien_salaire <= 0 
        THEN 1 ELSE 0 
    END) AS Ancien_Salaire_Invalide,

    SUM(CASE 
        WHEN nouveau_salaire <= 0 
        THEN 1 ELSE 0 
    END) AS Nouveau_Salaire_Invalide,

    SUM(CASE
        WHEN date_effet > GETDATE()
        THEN 1 ELSE 0
    END) AS Date_Effet_Future

FROM HistoriqueSalaire;
GO

--vérifier l'amplitude des salaires
SELECT
    MIN(ancien_salaire) AS Ancien_Salaire_Min,
    MAX(ancien_salaire) AS Ancien_Salaire_Max,
    MIN(nouveau_salaire) AS Nouveau_Salaire_Min,
    MAX(nouveau_salaire) AS Nouveau_Salaire_Max
FROM HistoriqueSalaire;
GO

--tableau de bord RH global
SELECT
    COUNT(*) AS Effectif_Total,

    SUM(CASE 
        WHEN statut = 'Actif' THEN 1 
        ELSE 0 
    END) AS Employes_Actifs,

    SUM(CASE 
        WHEN statut = 'Inactif' THEN 1 
        ELSE 0 
    END) AS Employes_Inactifs,

    CAST(AVG(salaire_actuel) AS DECIMAL(10,2))
        AS Salaire_Moyen,

    SUM(salaire_actuel)
        AS Masse_Salariale

FROM Employes;
GO

--taux de départ
SELECT
    COUNT(*) AS Effectif_Total,

    SUM(CASE
        WHEN date_depart IS NOT NULL THEN 1
        ELSE 0
    END) AS Nombre_Departs,

    CAST(
        100.0 *
        SUM(CASE
            WHEN date_depart IS NOT NULL THEN 1
            ELSE 0
        END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS Taux_Depart_Pct

FROM Employes;
GO

--analyser les effectifs par département
SELECT
    d.nom_departement,
    COUNT(e.id_employe) AS Nombre_Employes,

    SUM(CASE
        WHEN e.statut = 'Actif' THEN 1
        ELSE 0
    END) AS Employes_Actifs,

    SUM(CASE
        WHEN e.statut = 'Inactif' THEN 1
        ELSE 0
    END) AS Employes_Inactifs,

    CAST(AVG(e.salaire_actuel) AS DECIMAL(10,2))
        AS Salaire_Moyen

FROM Departements d

LEFT JOIN Employes e
    ON d.id_departement = e.id_departement

GROUP BY
    d.id_departement,
    d.nom_departement

ORDER BY
    Nombre_Employes DESC;
GO

--analyse salariale (chercher la masse salariale par département)
SELECT
    d.nom_departement,
    COUNT(e.id_employe) AS Nombre_Employes,
    SUM(e.salaire_actuel) AS Masse_Salariale,
    CAST(AVG(e.salaire_actuel) AS DECIMAL(10,2)) AS Salaire_Moyen,
    MIN(e.salaire_actuel) AS Salaire_Minimum,
    MAX(e.salaire_actuel) AS Salaire_Maximum
FROM Departements d
INNER JOIN Employes e
    ON d.id_departement = e.id_departement
GROUP BY
    d.id_departement,
    d.nom_departement
ORDER BY Masse_Salariale DESC;
GO

--analyse des 60 employés au-dessus de la grille salariale par département
SELECT
    d.nom_departement,
    COUNT(*) AS Employes_Hors_Grille,
    CAST(
        AVG(e.salaire_actuel - p.salaire_max)
        AS DECIMAL(10,2)
    ) AS Depassement_Moyen
FROM Employes e
INNER JOIN Postes p
    ON e.id_poste = p.id_poste
INNER JOIN Departements d
    ON e.id_departement = d.id_departement
WHERE e.salaire_actuel > p.salaire_max
GROUP BY
    d.id_departement,
    d.nom_departement
ORDER BY Employes_Hors_Grille DESC;
GO

--analyse des départs et du tunover
--analyse des départs par département
SELECT
    d.nom_departement,
    COUNT(e.id_employe) AS Effectif_Total,

    SUM(
        CASE
            WHEN e.date_depart IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS Nombre_Departs,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN e.date_depart IS NOT NULL THEN 1
                ELSE 0
            END
        )
        / COUNT(e.id_employe)
        AS DECIMAL(5,2)
    ) AS Taux_Depart_Pct

FROM Departements d
INNER JOIN Employes e
    ON d.id_departement = e.id_departement

GROUP BY
    d.id_departement,
    d.nom_departement

ORDER BY Taux_Depart_Pct DESC;
GO

--évolution des départs dans le temps
SELECT
    YEAR(date_depart) AS Annee,
    COUNT(*) AS Nombre_Departs
FROM Employes
WHERE date_depart IS NOT NULL
GROUP BY YEAR(date_depart)
ORDER BY Annee;
GO

--analyser pourquoi les employés quittent l'entreprise
SELECT
    motif_depart,
    COUNT(*) AS Nombre_Departs,

    CAST(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER()
        AS DECIMAL(5,2)
    ) AS Pourcentage_Departs

FROM Employes
WHERE date_depart IS NOT NULL
GROUP BY motif_depart
ORDER BY Nombre_Departs DESC;
GO

--analyser les absentéisme
--identifier les principaux types d'absence
SELECT
    type_absence,
    COUNT(*) AS Nombre_Absences,
    SUM(nb_jours) AS Total_Jours_Absence,
    CAST(AVG(CAST(nb_jours AS DECIMAL(10,2))) AS DECIMAL(10,2))
        AS Duree_Moyenne
FROM Absences
GROUP BY type_absence
ORDER BY Total_Jours_Absence DESC;
GO

--absence par département
SELECT
    d.nom_departement,
    COUNT(a.id_absence) AS Nombre_Absences,
    SUM(a.nb_jours) AS Total_Jours_Absence,
    CAST(
        1.0 * SUM(a.nb_jours) / COUNT(DISTINCT e.id_employe)
        AS DECIMAL(10,2)
    ) AS Jours_Absence_Par_Employe
FROM Absences a
INNER JOIN Employes e
    ON a.id_employe = e.id_employe
INNER JOIN Departements d
    ON e.id_departement = d.id_departement
GROUP BY
    d.id_departement,
    d.nom_departement
ORDER BY Jours_Absence_Par_Employe DESC;
GO

--évolution temporelle d'absence
SELECT
    YEAR(date_debut) AS Annee,
    COUNT(*) AS Nombre_Absences,
    SUM(nb_jours) AS Total_Jours_Absence
FROM Absences
GROUP BY YEAR(date_debut)
ORDER BY Annee;
GO

--
SELECT
    MIN(date_debut) AS Premiere_Absence,
    MAX(date_debut) AS Derniere_Absence
FROM Absences;
GO

--analyse des eprformances des employés
--performance moyenne par département
SELECT
    d.nom_departement,

    COUNT(ev.id_evaluation) AS Nombre_Evaluations,

    CAST(
        AVG(ev.note_performance)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    CAST(
        AVG(CAST(ev.objectifs_atteints_pct AS DECIMAL(10,2)))
        AS DECIMAL(5,2)
    ) AS Objectifs_Atteints_Moyen_Pct

FROM Evaluations ev
INNER JOIN Employes e
    ON ev.id_employe = e.id_employe
INNER JOIN Departements d
    ON e.id_departement = d.id_departement

GROUP BY
    d.id_departement,
    d.nom_departement

ORDER BY Performance_Moyenne DESC;
GO

--évolution de la performance
SELECT
    YEAR(date_evaluation) AS Annee,

    COUNT(*) AS Nombre_Evaluations,

    CAST(
        AVG(note_performance)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    CAST(
        AVG(CAST(objectifs_atteints_pct AS DECIMAL(10,2)))
        AS DECIMAL(5,2)
    ) AS Objectifs_Moyens_Pct

FROM Evaluations

GROUP BY YEAR(date_evaluation)

ORDER BY Annee;
GO

--identifier les employés ayant les meilleures performances moyennes
SELECT TOP 10
    e.id_employe,
    e.nom,
    e.prenom,
    d.nom_departement,

    COUNT(ev.id_evaluation) AS Nombre_Evaluations,

    CAST(
        AVG(ev.note_performance)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    CAST(
        AVG(CAST(ev.objectifs_atteints_pct AS DECIMAL(10,2)))
        AS DECIMAL(5,2)
    ) AS Objectifs_Moyens_Pct

FROM Employes e

INNER JOIN Evaluations ev
    ON e.id_employe = ev.id_employe

INNER JOIN Departements d
    ON e.id_departement = d.id_departement

GROUP BY
    e.id_employe,
    e.nom,
    e.prenom,
    d.nom_departement

HAVING COUNT(ev.id_evaluation) >= 2

ORDER BY
    Performance_Moyenne DESC,
    Objectifs_Moyens_Pct DESC;
GO

--croiser performance + absentéisme + salaire
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    d.nom_departement,
    e.salaire_actuel,

    COUNT(DISTINCT ev.id_evaluation) AS Nombre_Evaluations,

    CAST(
        AVG(ev.note_performance)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    COALESCE(
        (
            SELECT SUM(a.nb_jours)
            FROM Absences a
            WHERE a.id_employe = e.id_employe
        ), 0
    ) AS Total_Jours_Absence

FROM Employes e

INNER JOIN Departements d
    ON e.id_departement = d.id_departement

LEFT JOIN Evaluations ev
    ON e.id_employe = ev.id_employe

GROUP BY
    e.id_employe,
    e.nom,
    e.prenom,
    d.nom_departement,
    e.salaire_actuel

ORDER BY Performance_Moyenne DESC;
GO

--création des vues
--vue synthétique des employés
CREATE VIEW vw_Employes_Analyse AS
SELECT
    e.id_employe,
    e.nom,
    e.prenom,
    e.sexe,
    e.date_naissance,
    e.date_embauche,
    e.date_depart,
    e.statut,
    e.salaire_actuel,
    e.ville,
    e.mode_travail,

    d.nom_departement,

    p.titre_poste,
    p.niveau,
    p.salaire_min,
    p.salaire_max,

    CASE
        WHEN e.salaire_actuel > p.salaire_max THEN 'Au-dessus du maximum'
        WHEN e.salaire_actuel < p.salaire_min THEN 'Sous le minimum'
        ELSE 'Dans la grille'
    END AS Statut_Grille_Salariale

FROM Employes e

INNER JOIN Departements d
    ON e.id_departement = d.id_departement

INNER JOIN Postes p
    ON e.id_poste = p.id_poste;
GO

--vérifier
SELECT TOP 20 *
FROM vw_Employes_Analyse;
GO

--vue centrée sur la performance et l'absentéisme par employé
CREATE OR ALTER VIEW vw_KPI_Departements AS

WITH Evaluation_Employe AS (
    SELECT
        id_employe,
        AVG(note_performance) AS Performance_Moyenne
    FROM Evaluations
    GROUP BY id_employe
),

Absence_Employe AS (
    SELECT
        id_employe,
        SUM(nb_jours) AS Total_Jours_Absence
    FROM Absences
    GROUP BY id_employe
)

SELECT
    d.id_departement,
    d.nom_departement,

    COUNT(e.id_employe) AS Effectif_Total,

    SUM(
        CASE
            WHEN e.statut = 'Actif' THEN 1
            ELSE 0
        END
    ) AS Employes_Actifs,

    SUM(
        CASE
            WHEN e.date_depart IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS Nombre_Departs,

    CAST(
        AVG(e.salaire_actuel)
        AS DECIMAL(10,2)
    ) AS Salaire_Moyen,

    SUM(e.salaire_actuel) AS Masse_Salariale,

    CAST(
        AVG(ev.Performance_Moyenne)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    COALESCE(
        SUM(a.Total_Jours_Absence),
        0
    ) AS Total_Jours_Absence

FROM Departements d

LEFT JOIN Employes e
    ON d.id_departement = e.id_departement

LEFT JOIN Evaluation_Employe ev
    ON e.id_employe = ev.id_employe

LEFT JOIN Absence_Employe a
    ON e.id_employe = a.id_employe

GROUP BY
    d.id_departement,
    d.nom_departement;
GO

--vérifier
SELECT *
FROM vw_KPI_Departements
ORDER BY Effectif_Total DESC;
GO

--vue centrée sur les départements
CREATE VIEW vw_KPI_Departement AS
SELECT
    d.id_departement,
    d.nom_departement,

    COUNT(DISTINCT e.id_employe) AS Effectif_Total,

    COUNT(DISTINCT CASE
        WHEN e.statut = 'Actif'
        THEN e.id_employe
    END) AS Employes_Actifs,

    COUNT(DISTINCT CASE
        WHEN e.date_depart IS NOT NULL
        THEN e.id_employe
    END) AS Nombre_Departs,

    CAST(
        AVG(e.salaire_actuel)
        AS DECIMAL(10,2)
    ) AS Salaire_Moyen,

    SUM(e.salaire_actuel) AS Masse_Salariale,

    CAST(
        AVG(ev.note_performance)
        AS DECIMAL(4,2)
    ) AS Performance_Moyenne,

    COALESCE(
        SUM(a.Total_Jours_Absence),
        0
    ) AS Total_Jours_Absence

FROM Departements d

LEFT JOIN Employes e
    ON d.id_departement = e.id_departement

LEFT JOIN Evaluations ev
    ON e.id_employe = ev.id_employe

LEFT JOIN (
    SELECT
        id_employe,
        SUM(nb_jours) AS Total_Jours_Absence
    FROM Absences
    GROUP BY id_employe
) a
    ON e.id_employe = a.id_employe

GROUP BY
    d.id_departement,
    d.nom_departement;
GO

--vérifier
SELECT *
FROM vw_KPI_Departements
ORDER BY Effectif_Total DESC;
GO
--récupérer le nom exact du fichier SQL Server pour Power BI
SELECT @@SERVERNAME AS Nom_Serveur;
GO

SELECT DB_NAME() AS Base_Actuelle;
GO