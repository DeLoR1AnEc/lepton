{ den, __findFile, ... }:
{
  lepton.systems.provides = {
    base = den.lib.parametric.atLeast {
      includes = [
        <lepton/boot>
        <lepton/boot/secure>
        <lepton/boot/greeter>

        <lepton/zram>
      ];
    };
  };
}