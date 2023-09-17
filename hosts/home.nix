# Credits to: https://github.com/MatthiasBenaets/nixos-config

{ config, lib, pkgs, user, ... }:

{ 
    imports =                                   # Home Manager Modules
        (import ../modules/programs) ++
        (import ../modules/services);

    home = {
        username = "${user}";
        homeDirectory = "/home/${user}";

        packages = with pkgs; [

            # Terminal
            btop              # Resource Manager
            lf                # File Manager
            tldr              # Helper
            riggrep           # grep alt
            fzf               # Fuzzy finder
            exa               # ls alt
            bat               # cat alt
            zoxide            # cd alt

            # Video/Audio
            feh                # Image Viewer
            mpv                # Media Player
            vlc                # Media Player
            cava               # Audio visualizer
            #pavucontrol       # Audio Control
            #stremio           # Media Streamer
            #plex-media-player # Media Player

            # Apps
            brave              # Browser
            libreoffice        # Office Tools
            gimp               # Image editor
            gparted            # Disk partition
            #firefox           # Browser
            #remmina           # XRDP & VNC Client
            #appimage-run      # Runs AppImages on NixOS

            # File Management
            gnome.file-roller # Archive Manager
            okular            # PDF Viewer
            p7zip             # Zip Encryption
            rsync             # Syncer - $ rsync -r dir1/ dir2/
            unzip             # Zip Files
            unrar             # Rar Files
            zip               # Zip

            # General configuration
            jq		          # JSON processor
            killall           # Stop Applications
            usbutils          # USB Utility Info
            pciutils          # Computer Utility Info
            cmake
            gcc
            glibc
            gnumake
            gcolor2           # Color selector
            #trash-cli        # Trashcan 
            #alsa-utils	      # Audio Commands
            #git              # Repositories
            #nano             # Text Editor
            #pipewire         # Sound
            #pulseaudio	      # Audio Commands
            #wacomtablet      # Wacom Tablet
            #wget             # Downloader
            #socat		      # Data Transfer
            #thunar           # File Manager
            #zsh              # Shell
      
            # General home-manager
            udiskie           # Auto Mounting
            #alacritty        # Terminal Emulator
            #dunst            # Notifications
            #doom emacs       # Text Editor
            #libnotify        # Dependency for Dunst
            #neovim           # Text Editor
            #rofi             # Menu
            #rofi-power-menu  # Power Menu
            #vim              # Text Editor
      
            # Wayland configuration
            #autotiling       # Tiling Script
            #eww-wayland	  # Bar
            #grim             # Image Grabber
            #slurp            # Region Selector
            #swappy           # Screenshot Editor
            #swayidle         # Idle Management Daemon
            #waybar           # Bar
            #wev              # Input Viewer
            #wl-clipboard     # Console Clipboard
            #wlr-randr        # Screen Settings
            #xwayland         # X for Wayland
      
            # Wayland home-manager
            pamixer          # Pulse Audio Mixer
            #swaylock-fancy   # Screen Locker
      
            # Desktop
            #ansible          # Automation
            #blueman          # Bluetooth
            #deluge           # Torrents
            #discord          # Chat
            #ffmpeg           # Video Support (dslr)
            #gmtp             # Mount MTP (GoPro)
            #gphoto2          # Digital Photography
            #handbrake        # Encoder
            #heroic           # Game Launcher
            #hugo             # Static Website Builder
            #lutris           # Game Launcher
            #mkvtoolnix       # Matroska Tool
            #nvtop            # Videocard Top
            #plex-media-player# Media Player
            #prismlauncher    # MC Launcher
            #steam            # Games
            #simple-scan      # Scanning
            #sshpass          # Ansible dependency
       
            # Laptop
            #cbatticon        # Battery Notifications
            #blueman          # Bluetooth
            #light            # Display Brightness
            #simple-scan      # Scanning
            #brillo           # Backlight and keyboard LED 
      
            # Flatpak
            bottles           # Wineprefix manager
            #obs-studio       # Recording/Live Streaming

            # Virtual Machines
            #qemu-kvm
            #libvirt
            #virt-viewer

            # Themes
            gtk3
            gtk4
            qt5.qtwayland
            qt6.qmake
            qt6.qtwayland
            lxappearance

            # Others
            neofetch
            figlet
            lolcat
            figlet
            cmatrix
            ponysay
            pokemonsay
            catimg
            tty-clock


        ];


        file.".config/wall".source = ../modules/themes/wall;
        file.".config/wall.mp4".source = ../modules/themes/wall.mp4;


        pointerCursor = {                         # This will set cursor system-wide so applications can not choose their own
            gtk.enable = true;
            #name = "Dracula-cursors";
            name = "Catppuccin-Mocha-Dark-Cursors";
            #package = pkgs.dracula-theme;
            package = pkgs.catppuccin-cursors.mochaDark;
            size = 16;
        };

        stateVersion = "23.05";

    };

    programs = {
        home-manager.enable = true;
    };

    gtk = {                                     # Theming
        enable = true;
        theme = {
            #name = "Dracula";
            name = "Catppuccin-Mocha-Compact-Blue-Dark";
            #package = pkgs.dracula-theme;
            package = pkgs.catppuccin-gtk.override {
                accents = ["blue"];
                size = "compact";
                variant = "mocha";
            };
        };
        
        iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
        };

        font = {
            #name = "JetBrains Mono Medium";
            name = "FiraCode Nerd Font Mono Medium";
        };                                        # Cursor is declared under home.pointerCursor
    };

    systemd.user.targets.tray = {               # Tray.target can not be found when xsession is not enabled. This fixes the issue.
        Unit = {
            Description = "Home Manager System Tray";
            Requires = [ "graphical-session-pre.target" ];
        };
    };
}
