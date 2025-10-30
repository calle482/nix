# configuration.nix. Example of all options that are explained below.

{ config, lib, pkgs, ... }:

{
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    managementSystem.systemd-socket.enable = true;
    dataDir = "/apps/minecraft";
    servers = {
      survival = {
        enable = true;
        openFirewall = true;
        autoStart = false;
        package = pkgs.fabricServers.fabric-1_21_10;
        serverProperties = {
          gamemode = "survival";
          difficulty = "normal";
          simulation-distance = "32";
          white-list = true;
          motd = "Trongull";
        };
        operators = {
          Callecraft2 = "72146791-fd37-4a77-acfa-ab6749c48794";
        };
        whitelist = {
          Callecraft2 = "72146791-fd37-4a77-acfa-ab6749c48794";
        };
        jvmOpts = "-Xms16G -Xmx16G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1";
          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (
              builtins.attrValues {
                Fabric-API = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/lxeiLRwe/fabric-api-0.136.0%2B1.21.10.jar";
                  sha512 = "d6ad5afeb57dc6dbe17a948990fc8441fbbc13a748814a71566404d919384df8bd7abebda52a58a41eb66370a86b8c4f910b64733b135946ecd47e53271310b5";
                };
                C2ME = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/VSNURh3q/versions/eY3dbqLu/c2me-fabric-mc1.21.10-0.3.5.0.0.jar";
                  sha512 = "a3422b75899a9355aa13128651ed2815ff83ff698c4c22a94ea7f275c656aff247440085a47de20353ff54469574c84adc9b428c2e963a80a3c6657fb849825d";
                };
                Lithium = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/oGKQMdyZ/lithium-fabric-0.20.0%2Bmc1.21.10.jar";
                  sha512 = "755c0e0fc7f6f38ac4d936cc6023d1dce6ecfd8d6bdc2c544c2a3c3d6d04f0d85db53722a089fa8be72ae32fc127e87f5946793ba6e8b4f2c2962ed30d333ed2";
                };
                FerriteCOre = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/uXXizFIs/versions/CtMpt7Jr/ferritecore-8.0.0-fabric.jar";
                  sha512 = "131b82d1d366f0966435bfcb38c362d604d68ecf30c106d31a6261bfc868ca3a82425bb3faebaa2e5ea17d8eed5c92843810eb2df4790f2f8b1e6c1bdc9b7745";
                };
                DistantHorizons = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
                  sha512 = "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc";
                };
                TabTPS = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/cJCLKiAC/tabtps-fabric-mc1.21.10-1.3.29.jar";
                  sha512 = "211e99199774da8b72913719a0527a0ead1aace45af1bad41be8dc1aba536e850b27ee8aa9b1d5c69e23364b368eaa912026e7c346294e65a68a01a5303c5962";
                };
                Ledger = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/LVN9ygNV/versions/O4Rna8OX/ledger-1.3.16.jar";
                  sha512 = "1efdb3ea0882e47110aabcf82675d4c124517bb36140c4a85e8acf7b52c107e795468ae3562ce18ed2ed02e6fc2172b5f5832ca2efdd2c540c31d40fa2371367";
                };
                Fabric-Language-Kotlin = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/LcgnDDmT/fabric-language-kotlin-1.13.7%2Bkotlin.2.2.21.jar";
                  sha512 = "0453a8a4eb8d791b5f0097a6628fae6f13b6dfba1e2bd1f91218769123808c4396a88bcdfc785f1d6bca348f267b32afc2aa9e0d5ec93a7b35bcfe295268c7bc";
                };
                Spark = pkgs.fetchurl {
                  url = "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar";
                  sha512 = "f99295f91e4bdb8756547f52e8f45b1649d08ad18bc7057bb68beef8137fea1633123d252cfd76a177be394a97fc1278fe85df729d827738d8c61f341604d679";
                };
              }
            );
          };
        };
      };
    };

  environment.persistence."/persistent".directories = [
    "/apps/minecraft"
  #  "/etc/systemd/system/minecraft-server-survival.service"
  ];
}
