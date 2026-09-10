# Réseau

CyberLab ne publie aucun port et n'ajoute aucune capability par défaut. Les
scanners HTTP, les outils passifs et les connexions sortantes fonctionnent sans
configuration supplémentaire.

La capture de paquets avec `tcpdump` peut nécessiter `NET_RAW` et `NET_ADMIN` :

```bash
docker run --rm -it --cap-add NET_RAW --cap-add NET_ADMIN cyberlab:latest
```

Ces permissions ne doivent être ajoutées que pour une tâche qui les exige. La
V1 ne configure pas de VPN dans le conteneur et ne monte jamais le socket Docker,
le répertoire personnel complet ou les clés SSH de l'hôte.
