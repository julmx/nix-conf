# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../modules/system.nix
      ../../modules/i3.nix

      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking.hostName = "mainPC"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  ##networking.defaultGateway = "192.168.1.254";

  # AMD GPU stuff
  # OpenCL
  hardware.opengl.extraPackages = with pkgs; [
  rocmPackages.clr.icd
  # amdvlk : The AMDVLK drivers can be used in addition to the Mesa RADV drivers. The program will choose which one to use
  amdvlk
  ];
  # Vulkan
  hardware.graphics.enable32Bit = true; # For 32 bit applications

  # For 32 bit applications 
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # Dual monitor configuration.
  services.xserver.xrandrHeads = [
   {
    output = "DisplayPort-1";
    primary = true;
    monitorConfig = ''Option "RightOf" "HDMI-A-0"'';
   }
   {
    output = "HDMI-A-0";
    monitorConfig = ''Option "LeftOf" "DisplayPort-1"'';
   }
  ];

 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}


