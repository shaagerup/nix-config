{ nixpkgs, inputs, name }:

let 
  machine = "soren";
in
  nixpkgs.lib.nixosSystem {
    system = inputs.flake-utils.lib.system.x86_64-linux;
    modules = [
      ../system/machine/${name}
      inputs.home-manager.nixosModule.home-manager;
      ({  pkgs, lib, ... }):
        let
	in
	{
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
	  nix.settings.experimental-features = [ "nix-command" "flakes" ];
	  services.xserver.displayManager.gdm.enable = true;
	  services.xserver.displayManager.gnome.enable = true;
	  home-manager = {
	    useGlobalPkgs = true;
	    useUserPackages = true;
	    users.${machine} = {
	      home.packages = [
		pkgs.vim
	      ];
	      home = {
	        pointerCursor = {
	          gtk.enable = true;
	          package = pkgs.bibata-cursors;
	          name = "Bibata-Modern-Amber";
	          size = 32;
	        };
		stateVersion = "23.05";
		username = ${machine};
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
	};
    ];
  };
