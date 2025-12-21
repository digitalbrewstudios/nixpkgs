{ lib, config, ... }:
{
  options = {
    name = lib.mkOption {
      type = lib.types.str;
      default = lib.getName config.package + "-with-config";
      description = ''
        Wrapped precommit package name.
      '';
    };

    runtimeInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = ''
        Inputs to include on pre-commit's PATH.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.path;
      apply = file: if lib.isDerivation file then file else "${file}";
      description = ''
        The config file for pre-commit.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The pre-commit package to wrap.
      '';
      internal = true;
    };
  };
}
