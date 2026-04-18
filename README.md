# Arch Dotfiles

Minimal and reproducible Arch Linux development environment focused on speed, low maintenance, and clean tooling.

## Features

- Modular installer architecture
- Safe to run multiple times (idempotent)
- Zsh + Oh My Zsh
- Autosuggestions + Syntax Highlighting
- Node.js via NVM
- Docker + Compose
- Hyprland-ready configs
- Ryzen Thermal Guard
- Automatic symlinks with backups
- Pacman + AUR support (`yay`)

## Quick Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayunierto/arch-dotfiles/main/bootstrap.sh)"
```

## Manual Install
```bash
git clone https://github.com/ayunierto/arch-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## Stack
- Shell: Zsh
- Framework: Oh My Zsh
- Runtime: Node.js (NVM)
- Containers: Docker
- WM: Hyprland
- Package Managers: Pacman + Yay

## Structure
```
.dotfiles/
├── install.sh
├── bootstrap.sh
├── modules/
├── lib/
├── config/
├── bin/
└── systemd/
```

## Principles
- Reproducible setup
- Fast shell startup
- Minimal dependencies
- Easy maintenance
- Developer-first workflow
- Supported System
- Arch Linux

## Notes

Scripts are safe to re-run. Existing configs are backed up automatically when needed.

## Useful Commands
```bash
# Git credentials
git config --global credential.helper store
```

# Install pnpm
```bash
npm i -g pnpm
```

## License
MIT

## Otras instalaciones
1. Docker 
```bash
sudo pacman -S docker  docker-compose
```
[Post install](https://docs.docker.com/engine/install/linux-postinstall)


2. [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/local-management/create-local-tunnel/#1-download-and-install-cloudflared). 

## Comandos utiles
```bash
# Guardar credeciales de git
git config --global credential.helper store
