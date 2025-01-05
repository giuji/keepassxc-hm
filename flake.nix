{

  description = "home-manager module for KeePassXC";
  
  inputs = {
    nixpks.url = "github:NixOS/nixpkgs/nixos-unstale";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeManagerModules = rec {
      keepassxc = import ./keepassxc.nix;
      default = keepassxc;
    };
  };

}
