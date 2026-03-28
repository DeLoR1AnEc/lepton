{ __findFile, ... }:
let
  username = "delorianec";
in
{
  den.aspects.${username} = {
    includes = [
      <den/primary-user>
    ];

    nixos.users.users.${username} = {
      initialHashedPassword = "$7$GU..../....442VWlj2O0QtUH32KxX51/$W/2FfevRD35BB6bJ182ctnVfYWJiboTBGGQiNVbFxK7";
    };
  };
}