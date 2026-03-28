{ den, __findFile, ... }:
{
  lepton = {
    base = den.lib.parametric.atLeast {
      includes = [
        <lepton/boot>
      ];
    };
  };
}