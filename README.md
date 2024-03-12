# Sharing Activities

## Introduction
Sharing Activities est une application qui permet de découvrir et participer à des activités de groupe. 
Ce Readme fournit des informations sur l'architecture, les fonctionnalités et le développement de l'application Sharing Activities.

## Architecture

### Langage de programmation
L'application Sharing Activities est développée en utilisant :
- Flutter avec le langage Dart pour le front-end
- NodeJS avec Express et également MongoDB/ Mongoose pour le back-end et la base de données

### Structure du projet
Le projet est organisé selon la structure suivante :

```
sharing_activities/
├── backend/ # Dossier du back-end du projet
| ├── app.js
| ├── features/ # Logique de structure séparée en fonctionnalités
│ | ├── activity/ # Chaque fonctionnalité contient 3 fichiers : controller, model et route
│ | | ├── activity.controller.js
│ | | ├── activity.model.js
│ | | └── activity.route.js
│ | ├── cart/
│ | └── user/
├── frontend/ # Dossier du front-end du projet
| ├── lib/
| | ├── main.dart
| | ├── src/
| | │ ├── features/ # Logique de structure séparée en fonctionnalités
| | | │ ├── activity/
| | | │ ├── authentication/ # Chaque fonctionnalité contient 3 dossiers : controllers, models et screens
| | | | │ ├── controllers/
| | | | │ ├── models/
| | | | │ └── screens/
| | | │ ├── cart/ 
| | | │ └── user/
| ├── assets/ # Ressources statiques (images)
│ |
| └── pubspec.yaml # Fichier de configuration de dépendances
```

## Fonctionnalités

Fonctionnalité | Description  | Fait partie du MVP ? | Est-elle réalisée ? |
:------------ | :-------------| :-------------| :-------------| 
US#1 : Interface de login |  <ul><li>- [x] Interface de connexion</li><li>- [x] 2 champs : "Login" et "Password"</li><li>- [x] Champ Password obfusqué</li><li>- [x] Bouton "Se connecter" : vérification en BDD</li><li>- [x] Appli fonctionnelle même si champs vides</li></ul> | :heavy_check_mark: | :heavy_check_mark:
US#2 : Liste des activités |  <ul><li>- [x] Une fois connecté, l'utilisateur arrive sur la page des activités</li><li>- [x] Liste déroulante de toutes les activités </li><li>- [x] Chaque activité affiche une image, un titre, un lieu et un prix</li><li>- [x] Au clic sur une entrée de la liste, le détail est affiché </li><li>- [x] La liste d'activités est récupérée de la BDD</li></ul> | :heavy_check_mark: | :heavy_check_mark:
US#3 : Détail d'une activité |  <ul><li>- [x] Cette page est composée de : une image, un titre, une catégorie, le lieu, le nombre de personnes minimum, le prix</li><li>- [x] Un bouton "Retour" pour retourner à la liste d'activités</li><li>- [x] Un bouton "Ajouter au panier"</li><li>- [x] Ajout de l'activité en BDD</li></ul> | :heavy_check_mark:| :heavy_check_mark:
US#4 : Le panier |  <ul><li>- [x] Au clic sur le bouton "Panier", la liste des activités du panier de l'utilisateur est affichée</li><li>- [x] Les informations par activité : Une image, un titre, le lieu, le prix</li><li>- [x] Un total général est affiché à l'utilisateur</li><li>- [x] A droite de chaque activité : Une croix pour retirer le produit</li><li>- [x] Au clic, le produit est retiré de la liste et le total est mis à jour</li><li>- [x] Aucun autre bouton n'est présent sur cette page</li></ul> | :heavy_check_mark:| :heavy_check_mark:
US#5 : Profil utilisateur | <ul><li>- [x] Au clic sur le bouton « Profil », les informations de l’utilisateur s’affichent</li><li>- [x] Les informations : Le Login ( readonly), le password (obfusqué), l'anniversaire, l'adresse, le code postal, la ville</li><li>- [x] Un bouton "valider" pour sauvegarder les données (en BDD)</li><li>- [x] Un bouton "Se déconnecter" pour revenir à la page de Login</li></ul> | :heavy_check_mark:| :heavy_check_mark:
US#6 : Filtrer sur la liste des activités | <ul><li>- [x] Sur la page « Activités », une TabBar est présente, listant les différentes catégories d’activités</li><li>- [x] Par défaut, l’entrée « Toutes » est sélectionnée et toutes les activités sont affichés</li><li>- [x] Au clic sur une des entrées, la liste est filtrée pour afficher seulement les activités correspondantes à la catégorie sélectionnée</li></ul> | :x: | :heavy_check_mark: 

## Développement

### Installation des dépendances 
Pour installer les dépendances du projet, exécutez la commande suivante dans le répertoire frontend du projet :
```
cd frontend
```
```
flutter pub get
```
Pour installer les dépendances du projet, exécutez la commande suivante dans le répertoire backend du projet :
```
cd backend
```
```
npm install
```
### Exécution de l'application
#### Pour le backend :

```
npm run dev
```

#### Pour le frontend : 
Les tests ont été réalisés avec Vscode et le navigateur "Chrome - Web-javascript" intégrée.<Br/>
Se positionner sur le fichier "main.dart" et appuyer sur l'icône de démarrage de l'application.

## Auteure
Cassandra Forestier
