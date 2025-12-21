{
  lib,
  pkgs,
  pre-commit,
}:
{
  /**
    Evaluate a pre-commit configuration.evalConfig

    # Type

    ```
    Module -> Configuration
    ```

    # Inputs
    `module`
    : A pre-commit module. See [options reference](#sec-precommit-option-reference).
  */
  evalConfig =
    module:
    lib.evalModules {
      class = "precommitConfig";
      specialArgs.modulesPath = ./modules;
      modules = [
        {
          _file = "pre-commit.evalConfig";
          _module.args.pkgs = lib.mkOptionDefault pkgs;
          package = lib.mkOptionDefault pre-commit;
        }
        {
          _file = "<pre-commit.evalConfig args>";
          imports = lib.toList module;
        }
        ./modules/default.nix
      ];
    };
}
