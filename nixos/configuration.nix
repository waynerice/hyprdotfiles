# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # import the Home manager module
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # enables the necessary PAM module that allows KWallet to be unlocked upon login.
  # KDE KWallet must be the same as login
  #KDE security.pam.services.sddm.kwallet.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  programs.hyprland.enable = false;
  # Optionally, enable xdg-desktop-portal-hyprland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];

  # Enable the !KDE/hyprland Plasma Desktop Environment.
  #KDE services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  #KDE services.desktopManager.plasma6.enable = true;

  # Enable GNOME and GDM
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #services.desktopManager.gnome.enable = true;
  #services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skullnix = {
    isNormalUser = true;
    description = "Skull Nix";
    extraGroups = [ "networkmanager" "wheel" "storage" "optical" "audio" "video" ];
    packages = with pkgs; [
      #KDE kdePackages.kate
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  #KDE services.displayManager.autoLogin.enable = true;
  #KDE services.displayManager.autoLogin.user = "skullnix";
  #services.getty.autologinUser = "skullnix";

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #kitty
    wget
    curl
    gparted
    #neovim
    udiskie
    udisks2
    ntfs3g
    exfat
    neofetch
    #git
    stow
    #wofi
    #waybar
    (google-chrome.override {
      commandLineArgs = "--ozone-platform-hint=auto";
    })
    hyprshot
    swaynotificationcenter
    libnotify
    hyprpaper
    hyprpicker
    hypridle
    hyprlock
    pavucontrol
    pamixer
    wev
    ripgrep
    fd
    gcc
    gcc-arm-embedded
    openocd
    cutecom
    meld
    python3
    lua
    bear
    gnumake
    luajitPackages.luarocks
    cliphist
    lazygit
    unzip
    bat
    wlogout
    fzf
    feh
    imlib2Full
    networkmanagerapplet
    nodejs_22
    tree
    #ranger
    #rmpc
    qalculate-gtk
    gnome-calculator

    # ---- Packages for Mopidy/GStreamer ---- #
    # Provides the 'gi' Python module that was missing
    #python3.pkgs.pygobject
    python312Packages.pygobject3

    # Core library needed by pygobject
    gobject-introspection

    # A full set of GStreamer plugins for playing various audio formats
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad  # Often needed for common formats like MP3
    gst_all_1.gst-plugins-ugly # More codecs
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts = {
    packages = with pkgs; [
      font-awesome
      nerd-fonts.hack
      liberation_ttf
      fira-code
      fira-code-symbols
      # Add other fonts here
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
    # fonts.fontconfig.enable = true;
  };

  # List services that you want to enable:
  services.udisks2.enable = true;
  services.udisks2.mountOnMedia = true;
  # Enable polkit (required for udisks2)
  security.polkit.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Configure Home Manager
  home-manager.users.skullnix = {
    # This imports the user's specific configuration from their home directory
    imports = [ ./home.nix ];
  };

  # You can also set this option to true if you want Home Manager
  # to use the same nixpkgs version as your system.
  # home-manager.useGlobalPkgs = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
