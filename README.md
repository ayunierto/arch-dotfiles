# Dotfiles

Configuración personal para entorno de desarrollo en WSL (Ubuntu) enfocada en:

- Simplicidad
- Reproducibilidad
- Bajo mantenimiento
- Buen rendimiento

## Preview

Shell minimal con:
- zsh + autosuggestions
- syntax highlighting
- tooling moderna (fzf, ripgrep, bat)

Diseñado para WSL2 + Ubuntu LTS.

## Estructura

```
.dotfiles/
 ├── install.sh
 ├── bootstrap.sh
 ├── .zshrc
 ├── .aliases
 ├── .exports
 └── .gitconfig
 ```

 ## Stack

- Shell: zsh
- Framework: oh-my-zsh
- Plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
- Node: nvm
- Herramientas:
  - fzf
  - ripgrep
  - bat

## Philosophy

- Reproducible setup (bootstrap + install scripts)
- Minimal dependencies
- Fast shell startup
- No heavy theming or unnecessary plugins
- WSL-first workflow

## Supported Environments

- WSL2 (Ubuntu 22.04 / 24.04)
- Native Linux (Ubuntu-based)

Not tested on macOS or non-Debian distros.

## Bootstrap Flow

bootstrap.sh
  → installs git (if missing)
  → clones dotfiles repo
  → executes install.sh

install.sh
  → installs system packages
  → configures zsh + plugins
  → installs nvm + Node
  → links dotfiles

  ## Idempotency

Scripts are safe to run multiple times.

- Existing installations are detected
- Config files are backed up if needed
- No duplicate installations

---

## Instalación rápida (bootstrap)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayunierto/wsl-ubuntu-dotfiles/main/bootstrap.sh)"
```

## Instalación manual
```bash
git clone https://github.com/ayunierto/wsl-ubuntu-dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## Otras instalaciones
1. [Docker](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
2. [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/local-management/create-local-tunnel/#1-download-and-install-cloudflared). [Post install](https://docs.docker.com/engine/install/linux-postinstall)
