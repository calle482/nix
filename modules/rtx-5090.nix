{ config, ... }:

{

  systemd.services.nvidia-settings = {
    enable = true;
    description = "Set up Nvidia settings";
    wants = [ "basic.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/usr/bin/nvidia-smi -pl 403";
    };
  };

}
