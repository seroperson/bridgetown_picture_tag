{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ruby-nix = {
      url = "github:inscapist/ruby-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    bundix,
    ruby-nix
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [(self: super: {
        defaultGemConfig = super.defaultGemConfig // {
        };
      })];
    };
    rubyNix = ruby-nix.lib pkgs;

    rubyDep = pkgs.ruby_3_1;

    # Running bundix would regenerate `gemset.nix`
    bundixcli = bundix.packages.${system}.default;

    inherit (rubyNix {
      ruby = rubyDep;
      name = "bridgetown-picture-tag";
      gemset = ./gemset.nix;
      gemConfig = pkgs.defaultGemConfig // { };
    }) env ruby;

    deps = [
      env ruby bundixcli

      pkgs.vips pkgs.imagemagick
    ];
  in {
    packages.${system} = let
      bundlecli = pkgs.writeShellApplication {
        name = "bundle";
        runtimeInputs = deps;
        text = ''
          export BUNDLE_PATH=vendor/bundle
          bundle "$@"
        '';
      };
      rakecli = pkgs.writeShellApplication {
        name = "rake";
        runtimeInputs = deps;
        text = ''
          export BUNDLE_PATH=vendor/bundle
          rake "$@"
        '';
      };
    in {
      bundle = bundlecli;
      bundix = bundixcli;
      rake = rakecli;
      default = bundlecli;
    };

    devShells.${system}.default = pkgs.mkShell {
      shellHook = ''
        export BUNDLE_PATH=vendor/bundle
      '';
      buildInputs = deps;
    };
  };
}
