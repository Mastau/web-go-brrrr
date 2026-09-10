# CyberLab

CyberLab est une image Docker unique destinée aux CTF web, à la formation et
aux travaux de bug bounty autorisés. Elle fournit un environnement terminal
reproductible, non-root et compatible Linux `amd64` et macOS Apple Silicon.

## Fonctionnalités de la V1

Cette première version privilégie un laboratoire web unique, fiable et simple
à maintenir. Elle ne contient volontairement ni desktop, ni profils dynamiques,
ni CLI dédiée, ni VPN embarqué.

### Environnement

- image unique `cyberlab:latest` basée sur Debian 12 Slim ;
- environnement terminal avec Zsh comme shell par défaut ;
- Git, tmux, Vim, Nano, fzf, ripgrep, curl et jq ;
- Python 3, pip, pipx, environnements virtuels et outils de compilation ;
- Go 1.25.7 fourni dans l'image ;
- build multi-stage pour ne conserver que les binaires Go et Rust nécessaires ;
- support des plateformes Linux `amd64` et `arm64`, dont macOS Apple Silicon
  avec OrbStack ou Docker Desktop.

### Sécurité et isolation

- sessions interactives exécutées par l'utilisateur non-root `lab` ;
- adaptation UID/GID sous Linux afin de conserver des fichiers utilisables par
  l'utilisateur hôte ;
- `sudo` disponible à l'intérieur du conteneur jetable ;
- aucun mode `--privileged`, port publié ou capability supplémentaire par
  défaut ;
- aucun VPN, secret ou identifiant intégré à l'image ;
- aucun montage implicite du socket Docker, du dossier personnel complet ou
  des clés SSH de l'hôte.

### Workspace persistant

- répertoire de travail unique `/workspace` dans le conteneur ;
- montage par défaut de `~/CyberLab` depuis l'hôte ;
- conservation des sources, notes, rapports et résultats après suppression ou
  recréation du conteneur ;
- fonctionnement validé avec les bind mounts OrbStack sur macOS ARM64.

### Outils de reconnaissance

- `subfinder` pour la découverte passive de sous-domaines ;
- `httpx` pour identifier et qualifier les services HTTP ;
- `gau` pour retrouver des URLs historiques ;
- `whatweb` pour identifier les technologies web ;
- `wafw00f` pour détecter les WAF ;
- `nmap` pour la découverte réseau et l'identification de services.

### Fuzzing et découverte de contenu

- `ffuf` ;
- `feroxbuster` ;
- `gobuster` ;
- `dirb` ;
- sélection compacte de wordlists fournie par `dirb`.

Les collections volumineuses comme SecLists ne sont pas embarquées. Elles
peuvent être placées dans le workspace selon les besoins.

### Recherche de vulnérabilités

- `nuclei` pour les contrôles basés sur des templates ;
- `sqlmap` pour les tests d'injection SQL ;
- `nikto` pour les contrôles de serveurs web ;
- `dalfox` pour les tests XSS ;
- `arjun` pour la découverte de paramètres HTTP.

Les templates Nuclei sont téléchargés dans la configuration de l'utilisateur
lors de la première utilisation afin de suivre leur cycle de mise à jour
indépendamment de celui de l'image.

### Réseau et diagnostic

- DNS : `dig`, `host` et `nslookup` ;
- HTTP/TLS : `curl`, `wget` et `openssl` ;
- réseau : `ping`, `iproute2`, `netcat`, `socat`, `traceroute` et `whois` ;
- capture : `tcpdump`, avec capabilities explicites lorsqu'elles sont requises.

### Maintenance et validation

- installateurs séparés entre socle, développement, réseau, web et wordlists ;
- entrypoint runtime indépendant des scripts de construction ;
- versions explicites pour les outils construits depuis leurs sources ;
- tests de syntaxe, présence des outils, utilisateur runtime et persistance ;
- documentation dédiée à l'architecture, aux outils, au réseau et à la sécurité
  dans [`docs/`](docs/).

## Prérequis

- Docker avec le plugin Compose ;
- environ 15 Go libres pour le build ;
- un répertoire hôte persistant (par défaut `~/CyberLab`).

## Démarrage rapide

```bash
./scripts/build
./scripts/start
./scripts/shell
```

Utilisez `./scripts/shell` pour ouvrir la session non-root. Une invocation brute
de `docker compose exec` doit préciser `--user lab`, car Docker n'exécute pas
l'entrypoint lors d'un `exec`.

Le répertoire `~/CyberLab` est monté dans `/workspace`. Supprimer ou recréer le
conteneur ne supprime donc pas les fichiers de travail.

Pour arrêter ou supprimer l'instance :

```bash
./scripts/stop
./scripts/stop --remove
```

Les variables suivantes permettent de changer les valeurs par défaut :

```bash
CYBERLAB_IMAGE=cyberlab:latest \
CYBERLAB_CONTAINER=cyberlab \
CYBERLAB_WORKSPACE="$HOME/CyberLab" \
./scripts/start
```

## Utilisation responsable

Utilisez ces outils uniquement sur des systèmes pour lesquels vous disposez
d'une autorisation explicite. CyberLab fournit un environnement de travail ; il
n'automatise pas la sélection des cibles ou l'exploitation de vulnérabilités.

## Réseau

Aucun port, VPN, périphérique TUN ou privilège étendu n'est activé par défaut.
Voir [docs/networking.md](docs/networking.md) pour les cas nécessitant des
options supplémentaires.

## Développement

```bash
./tests/static.sh
./tests/smoke-image.sh
./tests/smoke-runtime.sh
./tests/smoke-workspace.sh
```

L'architecture et les règles de maintenance sont documentées sous `docs/`.
