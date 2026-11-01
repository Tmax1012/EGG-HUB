# EGG-HUB

Prototype de navigateur de serveurs publics pour Steal An Egg.

## Contenu
- `main.lua` : interface mobile et liste les serveurs publics du jeu Roblox actuellement ouvert.
- `loader.lua` : charge `main.lua` depuis ce dépôt GitHub.
- `README.md` : documentation.

## Limite importante
L'API publique Roblox permet de lister les serveurs publics, leur identifiant et leur nombre de joueurs. Elle ne donne pas l'inventaire des œufs de chaque serveur. Le Finder d'œufs (top 5, mutations, rendement, date de découverte) reste donc désactivé tant qu'une source de données réelle n'est pas disponible. Aucun résultat n'est simulé.

## Installation
1. Ouvrir le jeu Roblox.
2. Charger le script dans un environnement de test autorisé.
3. Pour utiliser le chargeur, le dépôt doit contenir `main.lua` sur la branche `main`.

Les exécuteurs tiers peuvent enfreindre les règles de Roblox et exposer le compte à des sanctions. Ne partage jamais ton mot de passe ou ton cookie Roblox.
