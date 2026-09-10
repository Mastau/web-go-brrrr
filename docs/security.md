# Sécurité

- Utiliser CyberLab uniquement avec une autorisation explicite de la cible.
- Le processus interactif s'exécute sous l'utilisateur `lab`.
- `sudo` sans mot de passe est disponible dans le conteneur jetable ; il ne
  donne que les capabilities déjà accordées au conteneur.
- Aucun port, secret, VPN ou privilège réseau n'est configuré par défaut.
- Seul le workspace choisi est monté depuis l'hôte.
- Ne placez pas de secrets dans l'image ou dans le dépôt.
- Vérifiez les changements de version et reconstruisez régulièrement l'image.

L'entrypoint démarre brièvement comme root pour adapter l'UID/GID, puis utilise
`gosu`. Cette phase ne modifie pas récursivement le contenu du workspace.
