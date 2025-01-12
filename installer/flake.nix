{
  description = "My system conf";
  inputs = rec {
    # set the channel
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # enable home-manager
    home-manager.url = "github:nix-community/home-manager/master";
    # tell home manager to use the nixpkgs channel set above.
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # master channel
    nixmaster.url = "github:NixOS/nixpkgs";
    # doesn't seem to work. 
    iso.url = "github:nix-community/nixos-generators";
    # Set up an ssh key on github
  };
  outputs = { self, nixpkgs,  home-manager, iso, nixmaster, ...}:
    let
      system = "x86_64-linux";
      hostname = "installer";
      networking.hostname = "${hostname}";
      pkgs = import nixpkgs {
        # imports the system variable
        inherit system;
        # enable non free packages
        config = {
          allowUnfree = true;
        }; 
      };
      overlays = {
        nixmaster = final: prev: {
          nixmaster = (import nixmaster {
            inherit system;
            config = {
              allowUnfree = true;
            };
          });
        };
        iso = final: prev: {
          nixmaster = (import iso{
            inherit system;
          });
        };
      };
      # install helper functions
      lib = nixpkgs.lib;
    in {
      homeManagaerConfigurations = {
        installer = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = hostname;
          homeDirectory = ("/home/" + hostname);
          configuration = {
            imports = [
              (../machines + ("/" + hostname) + /homeManager.nix)
            ];
          };
        };
      };
      nixosConfigurations = {
        nixos = lib.makeOverridable lib.nixosSystem{
          # imports the system variable
          inherit system;
          # import the config file
          modules = [
            { nixpkgs.overlays = [ overlays.nixmaster ]; }
            # does not work: gives error command flake not found
            { nixpkgs.overlays = [ overlays.iso ]; }
            (../common/common.nix)
            (../machines + ("/" + hostname) + ("/" + hostname + ".nix"))
          ];
        };
      };
    }; 
}
