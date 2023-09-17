# My notes for NixOS

## Installing your flake from Boot ISO
```
$ sudo su
# nix-env -iA nixos.git
# git clone <repo url> /mnt/<path>
# nixos-intall --flake .#<host>
# reboot
/* login */
$ sudo rm -r /etc/nixos/configuration.nix
/* move build to desired location */
```

## Update the system using flakes
```
# sudo nixos-rebuild switch --flake ./<host>
```

## Update flake.lock
```
# nix flake update
```

## Items to consider
- mpd => nixos.wiki.hardware.audio
- bluetooth headset button => nixos.wiki.hardware.audio.bluetooth
- hyprland suggested setup
- fzf integration with zsh. visit nixos wiki fzf
- spelling checker for libreoffice
- MPD music player setup
- MPV
- set default browser
- redshift
- networkmanager and bluetooth applet
- Polkit autostart
