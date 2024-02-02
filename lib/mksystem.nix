{ nixpkgs, inputs, name }:

let
  machine = "soren";
  system = inputs.flake-utils.lib.system.x86_64-linux;
  extensions = inputs.nix-vscode-extensions.extensions.${system};
in
nixpkgs.lib.nixosSystem {
  system = system;
  modules = [
    ../system/machine/${name}
    inputs.home-manager.nixosModules.home-manager
    ({ pkgs, lib, ... }:
      let
      in
      {

        virtualisation.virtualbox.host.enable = true;
        users.extraGroups.vboxusers.members = [ "soren" ];
        sound.enable = true;
        security.rtkit.enable = true;
        services.ratbagd.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
        };
        hardware.pulseaudio.enable = false;
        virtualisation.docker.enable = true;
        nixpkgs.config.allowUnfree = true;
        users.users.${machine} = {
          isNormalUser = true;
          extraGroups = [ "wheel" "docker" "video" "audio" "kvm" "libvirtd" ];
          shell = pkgs.zsh;
        };
        hardware.opengl = {
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };
        security.polkit.enable = true;
        services.xserver.enable = true;
        services.spotifyd.enable = true;
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome = {
          enable = true;
          #extraGSettingsOverrides = ''
          #[org.gnome.desktop.input-sources]
          #sources='[('xkb', 'eu')]'
          #'';
          #extraGSettingsOverridePackages = [
          #  pkgs.gsettings-desktop-schemas
          #];
        };
        services.xserver.layout = "dk";
        #services.xserver.xkbVariant = "norman";
        programs.zsh.enable = true;
        programs.git.enable = true;
        programs.firefox.enable = true;
        programs.dconf.enable = true;
        services.gnome.evolution-data-server.enable = true;
        services.gnome.gnome-settings-daemon.enable = true;
        services.teamviewer.enable = true;
        environment.systemPackages = with pkgs; [
          teamviewer
        ];
        programs.evolution = {
          enable = true;
          plugins = [ pkgs.evolution-ews ];
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${machine} = {
            home.file.".config/monitors.xml" = {
              text = ''
                <monitors version="2">
                  <configuration>
                    <logicalmonitor>
                      <x>0</x>
                      <y>0</y>
                      <scale>1</scale>
                      <monitor>
                        <monitorspec>
                          <connector>DP-3</connector>
                          <vendor>LEN</vendor>
                          <product>LEN P27h-10</product>
                          <serial>0x4c503137</serial>
                        </monitorspec>
                        <mode>
                          <width>2560</width>
                          <height>1440</height>
                          <rate>59.951</rate>
                        </mode>
                      </monitor>
                    </logicalmonitor>
                    <logicalmonitor>
                      <x>6000</x>
                      <y>0</y>
                      <scale>1</scale>
                      <monitor>
                        <monitorspec>
                          <connector>DP-2</connector>
                          <vendor>LEN</vendor>
                          <product>LEN P27q-10</product>
                          <serial>0x01010101</serial>
                        </monitorspec>
                        <mode>
                          <width>2560</width>
                          <height>1440</height>
                          <rate>59.951</rate>
                        </mode>
                      </monitor>
                    </logicalmonitor>
                    <logicalmonitor>
                      <x>2560</x>
                      <y>0</y>
                      <scale>1</scale>
                      <primary>yes</primary>
                      <monitor>
                        <monitorspec>
                          <connector>DP-1</connector>
                          <vendor>LEN</vendor>
                          <product>LEN G34w-10</product>
                          <serial>URW0DDMR</serial>
                        </monitorspec>
                        <mode>
                          <width>3440</width>
                          <height>1440</height>
                          <rate>59.999</rate>
                        </mode>
                      </monitor>
                    </logicalmonitor>
                  </configuration>
                </monitors>
              '';
              force = true;
            };
            programs.vscode = {
              enable = true;

              extensions = with pkgs.vscode-extensions; [
                bbenoist.nix
                scala-lang.scala
                scalameta.metals
                github.copilot
                graphql.vscode-graphql
                graphql.vscode-graphql-syntax
                chenglou92.rescript-vscode
                eamodio.gitlens
              ] ++ [
                extensions.vscode-marketplace.bazelbuild.vscode-bazel
              ];
            };

            #xdg.portal.enable = true;
            #xdg.portal.config.common.default = "*";
            xdg.configFile."mimeapps.list".force = true;
            xdg.mimeApps = {
              enable = true;
              defaultApplications = {
                "text/html" = "firefox.desktop";
                "x-scheme-handler/http" = "firefox.desktop";
                "x-scheme-handler/https" = "firefox.desktop";
                "x-scheme-handler/about" = "firefox.desktop";
                "x-scheme-handler/unknown" = "firefox.desktop";
              };
            };
            home.packages = [
              pkgs.vim
              pkgs.spotify
              pkgs.gitkraken
              (pkgs.google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
              pkgs.jdk
              pkgs.onlyoffice-bin
              pkgs.kubectl
              pkgs.discord
              pkgs.chromium
              pkgs.jetbrains-toolbox
            ];
            dconf = {
              enable = true;
              settings = {
                "org/gnome/desktop/interface" = {
                  color-scheme = "prefer-dark";
                };
                "org/gnome/desktop/input-sources" = {
                  sources = [ (inputs.home-manager.lib.hm.gvariant.mkTuple [ "xkb" "dk" ]) ];
                  xkb-options = [ ];
                };
                "org/gnome/settings-daemon/plugins/power" = {
                  sleep-inactive-ac-type = "nothing";
                  sleep-inactive-battery-type = "nothing";
                };
                "org/gnome/desktop/session" = {
                  idle-delay = inputs.home-manager.lib.hm.gvariant.mkUint32  0;
                };
              };
            };
            home = {
              pointerCursor = {
                gtk.enable = true;
                package = pkgs.bibata-cursors;
                name = "Bibata-Modern-Amber";
                size = 32;
              };
              stateVersion = "23.05";
              username = "${machine}";
              homeDirectory = "/home/${machine}";
            };
            gtk = {
              enable = true;
            };
            programs.home-manager.enable = true;
            xdg.enable = true;
            programs.bash.enable = true;
            programs.fzf = {
              enable = true;
              enableZshIntegration = true;
            };
            programs.zsh = {
              enable = true;
              oh-my-zsh = {
                enable = true;
                theme = "agnoster";
                plugins = [ "git" "bazel" ];
              };
            };
          };
        };
      }
    )
  ];
}
