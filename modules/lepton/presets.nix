{ den, __findFile, ... }:
{
  lepton.presets._ = {
    desktop = den.lib.parametric.atLeast {
      includes = [
        # !TODO
      ];
    };
  };
}