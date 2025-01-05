{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.keepassxc;
  iniFormat = pkgs.formats.ini { };

in {

  options.programs.keepassxc = {
    enable = mkEnableOption "KeePassXC Password Manager";

    package = mkOption {
      type = types.package;
      default = pkgs.keepassxc;
      defaultText = literalExpression "pkgs.keepassxc";
      description = "The KeePassXC pacakge to install";
    };


    # It's fine to store ur keepassxc.ini publicly, see
    # https://github.com/keepassxreboot/keepassxc/discussions/10055
    settings = mkOption {
      type = iniFormat.type;
      default = { };
      description = ''
        Configuration written to file
        {file} `$XDG_CONFIG_HOME/keepassxc/keepassxc.ini`.
        If set, KeePassXC will complain about writing permission on start.
      '';
      example = literalExpression ''
        {
          GUI = {
            ApplicationTheme = "dark";
            MinimizeOnClose = true;
          };
          Security = {
            LockDatabaseIdleSeconds = 300;
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions =
      [ (hm.assertions.assertPlatform "programs.keepassxc" pkgs platforms.linux) ];

    home.packages = [ cfg.package ];

    xdg.configFile."keepassxc/keepassxc.ini" = mkIf (cfg.settings != { }) {
      source = iniFormat.generate "keepassxc.ini" cfg.settings;
    };
  };
  
}
