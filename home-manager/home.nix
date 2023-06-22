# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "martin";
    homeDirectory = "/home/martin";
  };

  home.packages = with pkgs; [ kubectl ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.kitty.enable = true;
  programs.terminator.enable = true;
  programs.git = {
    enable = true;
    userName = "Martin Pedersen";
    userEmail = "martin@m4r7.in";
    aliases = {
        co = "checkout";
    };
  };
  programs.jq.enable = true;
  programs.anyrun = {
    enable = true;
    config = {
        plugins = [
            inputs.anyrun.packages.x86_64-linux.applications
        ];
        position = "top";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
monitor = eDP-1,preferred,auto,1

env = XCURSOR_SIZE,24

input {
  follow_mouse = 2
  # force_no_accel = true
  sensitivity = -0.0
  accel_profile = flat
  float_switch_override_focus = false

}

device:synps/2-synaptics-touchpad {
  sensitivity = 0.5
}

general {
  col.active_border = rgba(33ccddee) rgba(00ff99ee) 45deg
  apply_sens_to_raw = true
}

decoration {
  rounding = 4
  blur = true
  blur_size = 3
  blur_passes = 1
  blur_new_optimizations = true
}

animations {
  enabled = false
}

misc {
  disable_splash_rendering = true
  vfr = true
}

windowrule = float, ^(Slack)$

bind = SUPER, Q, exec, kitty
bind = SUPER, R, exec, anyrun
bind = SUPER, V, togglefloating,
bind = CTRL ALT, T, exec, kitty
bind = SUPER, M, exit,
bind = SUPER, 1, exec, google-chrome-stable
bind = CTRL ALT, 1, workspace, 1
bind = CTRL ALT, 2, workspace, 2
bind = CTRL ALT, 3, workspace, 3
bind = CTRL ALT, H, workspace, e-1
bind = CTRL ALT, L, workspace, e+1
bind = ALT, H, movefocus, r
bind = ALT, K, movefocus, u
bind = ALT, J, movefocus, d
bind = ALT, L, movefocus, l
bindm = ALT, mouse:272, movewindow
bindm = ALT, mouse:273, resizewindow
'';
};

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
