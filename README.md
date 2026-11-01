# EGG-HUB V3 — Intelligence Suite

## Inclus
- Dashboard : session et nombre de joueurs du serveur actuel.
- Spawn Predictor : compte à rebours ancré manuellement sur un reset observé. La référence de 300 secondes vient d'un échantillon communautaire de cinq intervalles (293, 300, 300, 300, 307 s), en contexte Admin Abuse / update ; ce n'est pas un calendrier universel.
- Public Server Radar : liste les serveurs publics renvoyés par l'API Roblox, triés par places libres, et permet une tentative de téléportation.
- Fusion Intelligence : calcul manuel sur les valeurs saisies.
- Research Database : 13 groupes et 106 slots d'index observés. Les silhouettes ne prouvent pas les noms, raretés ni revenus.
- Personal Value Notebook : notes de valeur pendant la session.
- Interface tactile déplaçable.

## Limites importantes
Aucune lecture d'inventaires cachés, aucun vol automatisé, aucun remote non documenté, aucun contournement anti-cheat. Le radar public ne montre que le nombre de joueurs, la capacité et le ping lorsqu'ils sont fournis. Les calculs sont des estimations.

## Sources
- https://github.com/terrencerun/steal-an-egg-research
- https://stealaneggwiki.com/research/spawn-observations
- https://stealaneggwiki.com/all-eggs
- Roblox Place ID: 107778070777162
- Roblox Universe ID: 10563114921

## Installation
Remplace `main.lua` à la racine de `Tmax1012/EGG-HUB` par le fichier de ce pack. Conserve `loader.lua`.
Loader à une ligne :
`loadstring(game:HttpGet("https://raw.githubusercontent.com/Tmax1012/EGG-HUB/main/main.lua"))()`

Les exécuteurs tiers peuvent présenter des risques pour le compte et la sécurité.
