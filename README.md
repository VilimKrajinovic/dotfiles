# dotfiles

Personal + work dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Fresh-Mac bootstrap

Open Terminal on a new Mac and run, in order:

```sh
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi gh
gh auth login -h github.com -p https -w
chezmoi init --apply VilimKrajinovic/dotfiles
```

chezmoi will prompt for **profile** (`work` or `personal`) and **Git email** — answers persist to `~/.config/chezmoi/chezmoi.toml` and shape every templated file.

After init, the `run_once_*` and `run_onchange_*` scripts execute automatically:

| Script | Action |
|---|---|
| `run_onchange_after_10-brew-bundle.sh` | `brew bundle install` from `Brewfile.tmpl` |
| `run_once_after_20-macos-defaults.sh` | Dock / Finder / keyboard / screenshots tweaks |
| `run_once_after_30-language-runtimes.sh` | Node LTS via nvm, Python 3.13 via pyenv, OpenJDK 11 via jenv |
| `run_once_after_40-ssh-and-nvim.sh` | Generates SSH key, prompts to register on GitHub, clones `VilimKrajinovic/nvimconf` to `~/.config/nvim` |

## Manual follow-ups after bootstrap

These cannot be automated:

- Paste API keys into `~/.config/zsh/secrets.zsh` (created by run_once_40).
- Confirm new SSH key is added at <https://github.com/settings/keys>.
- macOS System Settings that aren't `defaults`-writable: Touch ID for sudo, Accessibility permissions for any apps that need them, Full Disk Access, Login Items.
- Sign in to GUI apps: 1Password, browsers, Slack, Spotify, etc.
- Log out and back in for some `defaults` to settle.

## Adding new dotfiles

```sh
chezmoi add ~/.config/some-tool/config.toml   # captures current state into the source dir
chezmoi cd                                     # opens shell in the source dir
git add -A && git commit -m "add some-tool config" && git push
```

## Profile templating

The `.profile` data key is `"work"` or `"personal"`. Use it in any `.tmpl` file:

```
{{ if eq .profile "work" -}}
# work-only content
{{- end }}
```

Currently gated to work:
- `~/.config/jobboard.kdl`, `virtualvalley.kdl`, `localstack.kdl` (via `.chezmoiignore`)
- `zjob`, `zvirtualvalley` functions and `zsqs` alias in `.zshrc`
- `localstack/tap` and `localstack-cli` in `Brewfile`

## Secrets

`~/.config/zsh/secrets.zsh` is sourced from `.zshrc` but **never** managed by chezmoi. It stays per-machine. Paste new API keys (Anthropic, OpenAI, GitHub PAT, etc.) into it after bootstrap.

For repo-managed secrets, see chezmoi's [age/gpg encryption](https://www.chezmoi.io/user-guide/encryption/) — not currently used here.

## Layout

```
dotfiles/
├── install.sh           # idempotent bootstrap script (manual re-run)
├── README.md            # this file
└── home/                # chezmoi source dir (set via .chezmoiroot)
    ├── .chezmoi.toml.tmpl
    ├── .chezmoiignore
    ├── dot_zshrc.tmpl
    ├── dot_zprofile
    ├── dot_p10k.zsh
    ├── dot_gitconfig.tmpl
    ├── dot_yarnrc
    ├── private_dot_ssh/config.tmpl
    ├── dot_config/
    │   ├── wezterm/wezterm.lua
    │   ├── kitty/kitty.conf
    │   ├── zellij/config.kdl
    │   ├── vim.kdl
    │   ├── jobboard.kdl        # work-only
    │   ├── virtualvalley.kdl   # work-only
    │   └── localstack.kdl      # work-only
    ├── Brewfile.tmpl
    └── run_*.sh(.tmpl)
```
