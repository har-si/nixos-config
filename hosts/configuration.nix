# Credits to: https://github.com/MatthiasBenaets/nixos-config

{ config, pkgs, lib, user, location, inputs, ... }:

{

    #Networking
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    
    #Locale
    time.timeZone = "Asia/Manila";
    i18n.extraLocaleSettings = "en_US.UTF-8";
    console = {
        fort = "Lat2-Terminux16";
        keyMap = "us";
        useXkbConfig = true; # user xkboptions in tty.
    };


    #User Settings
    users.users.${user} = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" "kvm" ];
        initialPassword = "1234";
        shell = pkgs.zsh;
    };

    
    #Fonts
    fonts.fonts = with pkgs; [
        carlito                                 #NixOS
        vegur                                   #NixOS
        powerline-fonts
        font-awesome                            #Icons
        corefonts                               #MS
        vistafonts                              #MS
        (nerdfonts.override {                   #Nerdfont Icons override
            fonts = [
            "FiraCode"
            "AnonymousPro"
            "CascadiaCode"
            "DroidSansMono"
            "EnvyCodeR"
            "JetBrainsMono"
            "Meslo"
            "Monoid"
            "SourceCodePro"
            ];
        })
    ];


    #Environment Variables
    environment = {
        variables = {
            TERMINAL = "kitty";
            EDITOR = "nvim";
            VISUAL = "nvim";
        };
        sessionVariables = rec {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";
            XDG_BIN_HOME = "$HOME/.local/bin";
            PATH = [
                "${XDG_BIN_HOME}"
            ];
        };
        shells = with pkgs; [ zsh ];
    };


    #Audio (Pipewire)
    sound.enable = false;       #Disable ALSA since we will use pipewire
    sound.mediaKeys.enable = true;
    hardware.pulseaudio.enable = false;     #Disable pulseaudio for pipewire
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
    };


    #Bluetooth settings
    hardware.bluetooth.enable = true;
    hardware.bluetooth.hsphfpd.enable = true;
    hardware.bluetooth.package = pkgs.bluez;
    services.blueman.enable = true;


    #Location
    services.locate = {
        enable = true;
        locate = pkgs.mlocate;
    };


    #OpenSSH
    services.openssh.enable = true;


    #System-wide Packages
    environment.systemPackages = with pkgs; [
        vim
        git
        wget
        curl
        firefox-wayland
        alsa-utils
        bluez-tools
        alejandra
        xdg-users-dirs
        pavucontrol
        libsForQt5.polkit-kde-agent
        libsecret
    ];


    #Other Packages or Services
    services.dbus.enable = true;
    services.tumbler.enable = true;     #DBus thumbnailer
    services.flatpack.enable = true;
    services.onedrive.enable = true;
    #services.teamviewer.enable = true;
    security.polkit.enable = true;
    programs.zsh.enable = true;


    #Keyring
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;    #GUI keyring manager


    #GUI File Manager (Thunar)
    programs = {
        thunar = {
            enable = true;
            plugins = with pkgs.xfce; [
                thunar-archive-plugin
                thunar-volman
                thunar-media-tags-plugin
                thunar-vcs-plugin
            ];
        };
    };


    #Discord overlay
    environment.systemPackages = [ pkgs.discord ];
    nixpkgs.overlays = [    # This overlay will pull the latest version of Discord
        (self: super: {
            discord = super.discord.overrideAttrs (
                _: { src = builtins.fetchTarball {
                    url = "https://discord.com/api/download?platform=linux&format=tar.gz";
                    sha256 = "0pml1x6pzmdp6h19257by1x5b25smi2y60l1z40mi58aimdp59ss";
                };}
            );
        })
    ];


    #Printing (without drivers)
    services.printing.enable = true;
    services.avahi = {          # Needed to find wireless printer
        enable = true;
        nssmdns = true;
        openFirewall = true;
        publish = {             # Needed for detecting the scanner
            enable = true;
            addresses = true;
            userServices = true;
        };
    };
        #Check Nixos wiki for driver-based printing


    #Scanning
    hardware.sane.enable = true;
        #Check nixos wiki for scanner drivers

    
    #NIXOS SETTINGS

    #Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    #Garbage colector
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
    };

    nix.settings.auto-optimise-store = true;

    system.stateVersion = "23.05";
  
    #Flakes
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };

}
