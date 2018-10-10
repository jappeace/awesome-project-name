{ accessKeyId, keyPair }:
let awesome = (import ./.);
    region = "us-west-2";
    zone = "${region}a";
in {
  network.description = "Awesome Network";

  apiServer = { config, pkgs, nodes, ... }:
  let amis = import (pkgs.path + "/nixos/modules/virtualisation/ec2-amis.nix");
      awesome-mini = pkgs.runCommand "awesome" {} ''
        mkdir $out
        cp ${awesome}/ghc/backend/bin/webservice $out
        cp -r ${awesome}/ghcjs/frontend/bin/webservice.jsexe/ $out/static
      '';
  in {

    users.extraGroups.awesomeuser = { };
    users.extraUsers.awesomeuser =
      { description = "Awesome User";
        group = "awesomeuser";
        createHome = true;
        home = "/home/awesomeuser";
        useDefaultShell = true;
      };

    systemd.services.awesome-project = {
      description = "Awesome Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${awesome-mini}/webservice ${awesome-mini}/static";
        KillSignal ="SIGINT";
        User = "awesomeuser";
        Restart = "always";
        WorkingDirectory = "/home/awesomeuser";
      };
    };

    services.postgresql = {
      enable = true;
      package = pkgs.postgresql100;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE awesomeuser WITH LOGIN;
        CREATE DATABASE awesome_db;
        GRANT ALL PRIVILEGES ON DATABASE awesome_db TO awesomeuser;

        \c awesome_db;

        CREATE TABLE ausers (
            id         SERIAL PRIMARY KEY,
            name       varchar(40) NOT NULL,
            email      varchar(40) NOT NULL
        );

        ALTER TABLE ausers OWNER TO awesomeuser;

        CREATE TABLE messages (
            id         SERIAL PRIMARY KEY,
            from__id   integer REFERENCES ausers(id),
            content    varchar(40) NOT NULL
        );

        ALTER TABLE messages OWNER TO awesomeuser;
      '';
    };


    networking.firewall.allowedTCPPorts = [ 6868 ];
    services.fail2ban.enable = true;

    deployment = {
      targetEnv = "ec2";
      hasFastConnection = true;
      ec2 = {
        inherit region zone accessKeyId keyPair;
        instanceType = "t2.micro";
        ami = amis."18.03".us-west-2.hvm-ebs;
        securityGroups = [ "awesome" ];
        ebsInitialRootDiskSize = 8;
      };
    };
  };
}
