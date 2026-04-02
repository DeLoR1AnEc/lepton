{
  lepton.apps._.shells =
    { user, ... }:
    {
      homeManager =
        let
          shellAliases = {

          };

          localBin = "/home/${user.userName}/.local/bin";
          goBin    = "/home/${user.userName}/go/bin";
          cargoBin = "/home/${user.userName}/.cargo/bin";
          npmBin   = "/home/${user.userName}/.npm/bin";
        in
        {
          programs.bash = {
            enable = true;
            enableCompletion = true;
          };

          home = {
            shellAliases = shellAliases;
            sessionPath = [ localBin goBin cargoBin npmBin ];
          };

          programs.nushell = {
            enable = true;
            configFile.source = ./config.nu;
            inherit shellAliases;
          };
        };
  };
}