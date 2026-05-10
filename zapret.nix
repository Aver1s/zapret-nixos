{ config, pkgs, ... }:

{
  systemd.services.zapret = {
    enable = true;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    description = "Custom Zapret Script Service";
    path = with pkgs; [ 
	  sudo 
	  git 
	  bash 
	  coreutils 
	  iptables 
	  nftables 
	  iproute2 
	  ipset 
	  gawk 
	  gnugrep
	  gnused
	  procps 
	  curl
	  findutils
	  which
    ];
    serviceConfig = {
        Type = "simple";
        WorkingDirectory="/opt/zapret/";
        User="root";
	
	Environment = "PATH=${pkgs.lib.makeBinPath (with pkgs; [ 
        iptables nftables iproute2 ipset coreutils gnugrep gnused gawk bash curl git ipset procps findutils which
      ])}:/opt/zapret";

         ExecStart = "${pkgs.bash}/bin/bash /opt/zapret/service.sh run --config /opt/zapret/conf.env";

        Restart = "on-failure";
        RestartSec = "5s";
    };
  };
}
