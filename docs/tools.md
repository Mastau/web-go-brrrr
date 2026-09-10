# Outils V1

| Catégorie | Outils principaux | Installation |
|---|---|---|
| Core | zsh, tmux, git, curl, jq, ripgrep, fzf, vim | Debian APT |
| Développement | Python 3, pipx, build-essential | Debian APT |
| Runtime Go | Go 1.25.7 | Toolchain officielle de l'étape Go |
| Réseau | nmap, tcpdump, netcat, socat, DNS, whois | Debian APT |
| Web Debian | sqlmap, whatweb, gobuster, dirb | Debian APT |
| Web Perl | nikto | Release officielle épinglée dans `install-web.sh` |
| Web Go | ffuf, nuclei, httpx, subfinder, gau | Build multi-stage, versions dans le Dockerfile |
| Web Rust | feroxbuster, dalfox | Build multi-stage Rust 1.93, versions dans le Dockerfile |
| Web Python | arjun, wafw00f | pipx, versions dans `install-web.sh` |

APT est volontairement préféré lorsqu'il fournit un outil adapté : les mises à
jour de sécurité suivent alors Debian 12. Les versions construites hors Debian
sont explicites afin qu'un changement soit visible en revue de code.

Les templates Nuclei sont téléchargés dans la configuration personnelle de
l'utilisateur lors de leur première utilisation. Ils ne sont pas figés dans
l'image car leur cadence de mise à jour est indépendante du binaire.

Les wordlists embarquées sont limitées à celles de `dirb`. Les collections plus
volumineuses doivent être placées sous `/workspace`.
