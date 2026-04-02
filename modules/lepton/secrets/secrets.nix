{ inputs, ... }:
let
  sopsConfig = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-age-key";
  };
in
{
  lepton.secrets = {
    nixos = {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = sopsConfig;
    };

    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        sops = sopsConfig;
        home.sessionVariables.SOPS_AGE_KEY_FILE = sopsConfig.age.keyFile;
        home.packages = [ pkgs.sops ];
      };
  };
}