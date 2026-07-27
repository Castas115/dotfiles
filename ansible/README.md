# ansible

Bootstrap de workstation Ubuntu 26.04 + Nix + Hyprland.

## Qué hace

- apt mínimo: hyprland, portals, kanata, deps de Nix
- Vivaldi via repo oficial apt (Chromium-family no funciona desde nix por SUID sandbox)
- Instala Nix (Determinate Systems)
- Configura kanata como servicio systemd (user + group input + uinput udev rule)
- Ejecuta `home-manager switch --flake ~/dotfiles/nixos#ubuntu` — esto trae terminales, waybar, fuentes, CLI, etc.

## Requisitos

```bash
sudo apt install -y ansible
```

## Ejecutar

Si tu sudo exige tty interactivo cada llamada (PAM `timestamp_type=tty`, 2FA hardware, etc.), `-K` falla con `Timed out waiting for become success`. Workaround estándar: NOPASSWD temporal.

```bash
echo "jon ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/99-jon-ansible
sudo chmod 440 /etc/sudoers.d/99-jon-ansible

cd ~/dotfiles/ansible
ansible-playbook -i localhost, -c local ubuntu-nix-setup.yml

sudo rm /etc/sudoers.d/99-jon-ansible
```

Si tu sudo es normal, basta:
```bash
ansible-playbook -K -i localhost, -c local ubuntu-nix-setup.yml
```

Dry-run añade `--check`.

Flags:
- `-K` pide sudo password
- `-i localhost,` inventory inline (coma obligatoria)
- `-c local` ejecuta in-place sin SSH

Idempotente — re-correr es seguro.

## Antes de correr

Edita o quita la task `Clone dotfiles` en `ubuntu-nix-setup.yml` (URL placeholder) si ya tienes el repo clonado en `~/dotfiles`.

## Tras éxito

```bash
hyprctl -j configerrors      # []
systemctl status kanata      # active
ghostty                      # abre sin EGL error
fc-list | grep -i jetbrains  # nerd font presente
```

## Hyprland 0.53 — porting manual

Si vienes de config Hyprland antigua:

- Borra bloque `gestures { }` (eliminado)
- `windowrulev2 = RULE, sel` → `windowrule = RULE sel`
- Nombres snake_case: `suppressevent` → `suppress_event`, `nofocus` → `no_focus`, `noinitialfocus` → `no_initial_focus`, `bordercolor` → `border_color`, `idleinhibit` → `idle_inhibit`, `noshadow` → `no_shadow`
- Regex selectors: `class:.*` → `class:^(.*)$`

## Qué NO está en ansible

- SMOWL — `.deb` desde panel del cliente, manual
- Config Hyprland — versionada en `~/dotfiles/.config/hypr/`
- Secretos — fuera del repo
