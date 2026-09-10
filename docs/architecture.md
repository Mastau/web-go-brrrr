# Architecture V1

CyberLab V1 produit une seule image et ne contient ni profils, ni générateur de
Dockerfile, ni CLI dédiée.

Le Dockerfile utilise deux étapes de compilation jetables pour les outils Go et
Rust. L'image finale Debian ne reçoit que leurs binaires et les paquets runtime.
Les installateurs sont classés par responsabilité afin de pouvoir devenir plus
tard des modules sans imposer aujourd'hui un moteur de profils.

À l'exécution, l'entrypoint ajuste l'UID et le GID de l'utilisateur `lab`, puis
abandonne les privilèges avec `gosu`. `/workspace` est le seul espace de travail
destiné à être monté depuis l'hôte.

Le Dockerfile ne dépend d'aucun binaire précompilé spécifique à une architecture :
les étapes Go et Rust compilent nativement pour la plateforme BuildKit ciblée.

## Flux

```text
installateurs catégorisés -> image cyberlab -> instance cyberlab
                                              -> /workspace monté depuis l'hôte
```
