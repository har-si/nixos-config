# Credits to: https://github.com/MatthiasBenaets/nixos-config

{ config, lib, pkgs, system, hyprland, ... }:


let
    exec = "exec dbus-launch Hyprland";


in
{

    #imports = [
    #    ../../programs/waybar.nix
    #    ../../programs/eww.nix
    #];


    programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland.enable = true;
        xwayland.hidpi = true;
        nvidiaPatches = false;
    };


    hardware = {
        opengl.enable = true;
        nvidia.modesetting.enable = false;
    };


    environment = {
        
        loginShellInit = ''
            if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
                ${exec}
            fi
        '';     # Will automatically open Hyprland when logged into tty1


        variables = {
            #WLR_NO_HARDWARE_CURSORS="1";  # Possible variables needed in vm
            #WLR_RENDERER_ALLOW_SOFTWARE="1";
            XDG_CURRENT_DESKTOP="Hyprland";
            XDG_SESSION_TYPE="wayland";
            XDG_SESSION_DESKTOP="Hyprland";
        };


        sessionVariables = {
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";

            NIXOS_OZONE_WL = "1";   #Hint electron apps to use wayland
        };


        systemPackages = with pkgs; [
            grim
            slurp
            swappy
            swaylock
            #swaylock-fancy
            wl-clipboard
            wlr-randr
            hyprpaper
            hyprpicker
        ];
    };


    security.pam.services.swaylock = {
        text = ''
            auth include login
        '';
    };


    xdg.portal = {      # Required for flatpak with window managers and for file browsing
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; #xdg-desktop-portal-hyprland pulled in by flake automatically
    };


    nixpkgs.overlays = [    # Waybar with experimental features
        (final: prev: {
            waybar = hyprland.packages.${system}.waybar-hyprland;
        })
    ];


  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];	# Install cached version so rebuild should not be required
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
