# /etc/nixos/home.nix
{ config, pkgs, ... }:

{
  # Set your home-manager state version
  # It's important to update this to the version of NixOS you are on
  home.stateVersion = "25.05"; 

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Example: Install a package
  home.packages = [
    pkgs.htop
    pkgs.kitty
    pkgs.neovim
    pkgs.git
    pkgs.gh
    pkgs.git-crypt
    pkgs.git-credential-keepassxc
    pkgs.wofi
    pkgs.waybar
    pkgs.keepassxc
    #pkgs.git-credential-manager
    #pkgs.rmpc
    pkgs.ncmpcpp
    pkgs.mpc-cli
  ];

  # Range .desktop setting
  xdg.desktopEntries."ranger-file-manager" = {
    name = "Ranger";
    comment = "Open Ranger in the Kitty terminal";
    icon = "kitty";
    # We no longer need the system to provide a terminal
    terminal = false;
    # We now call the terminal directly
    # exec = "kitty -e ranger";
    exec = "${pkgs.kitty}/bin/kitty -e ${pkgs.ranger}/bin/ranger";
    categories = [ "System" "FileTools" "FileManager" ];
  };

  # 1. Enable the Mopidy service
  services.mopidy = {
    enable = true;
    # 2. Tell Mopidy to load the YouTube extension
    extensionPackages = with pkgs; [
      mopidy-youtube
      mopidy-mpd
      ];
    # 3. Configure the extensions
    settings = {
      # This MPD block makes Mopidy listen for clients like rmpc
      mpd = {
        enabled = true;
        hostname = "127.0.0.1"; # Listen on localhost
        port = 6600;
      };
      # This block configures the YouTube extension
      youtube = {
        enabled = true;
        # Allows Browse YouTube Music charts, etc.
        musicapi_enabled = true;
        # You can also authenticate with your account for playlists,
        # but this requires extra setup with auth tokens.
      };
    };
  };

  #programs.yazi = {
  #  enable = true;

  #  # This block declaratively generates your keymap.toml
  #  keymap = {
  #    manager.keymaps = [
  #      {
  #        on = [ "e" ];
  #        run = "open --edit";
  #        desc = "Edit the selected file";
  #      }
  #      # ... you can add any other custom keybindings here
  #    ];
  #  };
  #};

  services.udiskie = {
    enable = true;
    automount = true; # Automatically mount new devices
    notify = true;    # Show notifications
    tray = "always";   # Or "always" if you use a system tray like waybar's
  };

  # For notifications to work, you need a notification daemon!
  # Mako is a great lightweight choice for Hyprland.
  #services.swaynotificationcenter.enable = true;
  #services.mako.enable = true;

  xdg.desktopEntries."yazi-file-manager" = {
    # You can name this entry anything you like
    name = "Yazi";
    comment = "Open the Yazi file manager in Kitty";
    icon = "utilities-terminal";
    
    # We will call the terminal ourselves
    terminal = false;

    # Use the full path to the kitty and yazi executables
    exec = "${pkgs.kitty}/bin/kitty -e ${pkgs.yazi}/bin/yazi";
    
    categories = [ "System" "FileTools" "FileManager" ];
  };

  # Create a keymap configuration file for Yazi
  xdg.configFile."yazi/keymap.toml".text = ''
    [[manager.keymaps]]
    on = [ "e" ]
    run = "open --edit"
    desc = "Edit the selected file"
  '';

  # 1. Install and set a visible cursor theme
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32; # Base size for the theme
  };


  # 2. Set the environment variable for cursor size
  # Set default editor for the user session
  home.sessionVariables = {
    XCURSOR_SIZE = "48"; # A good large size
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

}
