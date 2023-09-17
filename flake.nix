# Credits to: https://github.com/MatthiasBenaets/nixos-config

{
    description = "My NixOs Flakes for my Hyprland Setup";
  
    inputs = {

        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
        
        hyprland.url = "github:hyprwm/Hyprland";
    };


    outputs = inputs @ { self, nixpkgs, home-manager, hyprland, ...}: 

        let
            user = "azalea";
            location = "$HOME/flake";
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
	            config.allowUnfree = true;	
            };

            lib = nixpkgs.lib;

        in {
            nixosConfigurations = {
                azalea = lib.nixosSystem rec {
                    inherit system;
                    specialArgs = { inherit inputs hyprland user location system; };
                    modules = [ 
                        ./hosts/configuration.nix
                        ./hosts/laptop      #comment out if not using laptop
                        hyprland.nixosModules.default
                        home-manager.nixosModules.home-manager {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.${user} = {
                                imports = [./hosts/home.nix];
                            };
                            home-manager.extraSpecialArgs = specialArgs;
                        }
                    ];
                };
            };
        };
}

