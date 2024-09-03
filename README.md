# Projet 9: Optimisez un backend Apex

# Objectifs

- Optimiser l'application Salesforce pour réduire les erreurs et améliorer les performances.
- Réorganiser le code pour le rendre plus propre, maintenable et conforme aux bonnes pratiques.

# Installation

- Clôner le Github depuis l'onglet 'Clone'

# Tests

Tests Unitaires : Les classes de test sont incluses dans le répertoire /force-app/main/default/classes/.

- Exécutez-les via la console Salesforce ou votre VSC :

`sfdx force:apex:test:run` ou direcement depuis le code une commande cliquable est disponible `Run test`

# Objectifs :

- Optimiser l'application Salesforce pour réduire les erreurs et améliorer les performances.
- Réorganiser le code pour le rendre plus propre, maintenable et conforme aux bonnes pratiques.

# Amélioration

- Convention de nommage
- Utilidation des requêtes SOQL agrégée
- Création d'une classe de service pour calculer le chiffre d'affaire d'un account depuis ses orders
- Création d'une classe de service pour calculer le Net Amount sur plusieurs lignes de commande via Data Loader
- Batch réorganisé avec l'appel de la classe de service, lancement du batch, mettant à jour le chiffre d’affaires de tous les comptes lors de la migration des données
- Test unitaire avec une couverture à plus de 80% et respect des bonnes pratiques
