# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.hardware.nixosModules.lenovo-thinkpad-t14-amd-gen3
    # <nixos-hardware/lenovo/thinkpad/t14>
    # <nixos-hardware/lenovo/thinkpad/t14/amd>
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "thonk"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.gvfs.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.martin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
      git
    ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tmux
    htop
    google-chrome
    neovim
    gcc
    gnumake
    appgate-sdp
    slack
    nodejs
    rustup
    pipecontrol
    pw-volume
    pavucontrol
    # pulsemixer
    # helvum
  ];

  # Enable wayland in chrome/electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.bash = {
    shellAliases = {
      e = "nvim -p";
      edit = "nvim -p";
      tmuxa = "tmux a";
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
    };
    shellInit = ''
. ~/.bashrc
'';
  };
  programs.ssh = {
    startAgent = true;
  };
  programs.hyprland.enable = true;
  programs.mtr.enable = true;
  programs.light.enable = true;

  nix.settings = {
      builders-use-substitutes = true;
      substituters = [
          "https://hyprland.cachix.org"
          "https://anyrun.cachix.org"
      ];
      trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
  };

  system.stateVersion = "23.11";
}

