{ config, pkgs, user, ... }:

{

    imports =
        [(./hardware-configuration.nix)] ++
        [(../../modules/desktop/hyprland/default.nix)];


    # Bootloader.
    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.kernelModules = ["amdgpu"];         #kernel module for graphics card
    boot.loader.efi.efiSysMountPoint = "/boot";     #or use "/boot/efi"
    boot.loader.grub.enable = true;
    boot.loader.grub.devices = [ "nodev" ];
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.configurationLimit = 5;
    boot.loader.timeout = 5;
    boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
        pname = "distro-grub-themes";
        version = "3.1";
        src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        };
        installPhase = "cp -r customize/nixos $out";
    };


    #OpenGL AMD and Intel GPU Drivers
    hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
    ];
    hardware.opengl.driSupport = true;  #enable Vulkan


    #Enable Firmwares
    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;


    #Backlight (alternative to xbacklight)
    programs.dconf.enable = true;   
    programs.light.enable = true;
        # to use light:
        # `light -U 30` = darker
        # `light -A 30` = brighter
        # or use brightnessctl for systemd


    #Power Management
    powerManagement.enable = true;
    services = {
        thermald.enable = true;
        logind.lidSwitch = "hibernate";
        tlp = {
            enable = true;
            settings = {
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

                CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
                CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

                CPU_MIN_PERF_ON_AC = 0;
                CPU_MAX_PERF_ON_AC = 100;
                CPU_MIN_PERF_ON_BAT = 0;
                CPU_MAX_PERF_ON_BAT = 20;
            };
        };
    };

}
