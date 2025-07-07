# Base sshd config.
{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.baseSystem.ssh;
in
{
  options.baseSystem.ssh = {
    enable = mkEnableOption "SSH config";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.PasswordAuthentication = false;
    services.openssh.ports = [ 6969 ];
  };
}
