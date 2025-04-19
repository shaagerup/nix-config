{
  description = "Soren's nixos config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    let
      system = flake-utils.lib.system.x86_64-linux;
      machine = "soren";
      mkSystem = name: import ./lib/mksystem.nix {
        inherit nixpkgs inputs name;
      };
    in
    {
      nixosConfigurations.work = mkSystem "work";
      nixosConfigurations.home = mkSystem "home";
      nixosConfigurations.laptop = mkSystem "laptop";
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
    };
}
