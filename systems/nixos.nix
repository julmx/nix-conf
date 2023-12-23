args:
with args;
with allSystemAttrs; let
  nixosSystem = import ../lib/nixosSystem.nix;

  base_args = {
    inherit home-manager nixos-generators;
    inherit nixpkgs; # or nixpkgs-unstable
    system = x64_system;
    specialArgs = allSystemSpecialArgs.x64_system;
  };
in {
  nixosConfigurations = {
    # ai with i3 window manager
    ai_i3 = nixosSystem (idol_ai_modules_i3 // base_args);
    # ai with hyprland compositor
    ai_hyprland = nixosSystem (idol_ai_modules_hyprland // base_args);

    # three virtual machines without desktop environment.
    aquamarine = nixosSystem (idol_aquamarine_modules // base_args);
    ruby = nixosSystem (idol_ruby_modules // base_args);
    kana = nixosSystem (idol_kana_modules // base_args);
  };

  # take system images for idols
  # https://github.com/nix-community/nixos-generators
  packages."${x64_system}" = libAttrs.mergeAttrsList [
    (
      libAttrs.listToAttrs
      [
        "ai_i3"
        "ai_hyprland"
      ]
      # generate iso image for hosts with desktop environment
      (host: self.nixosConfigurations.${host}.config.formats.iso)
    )

    (
      libAttrs.listToAttrs
      [
        "aquamarine"
        "ruby"
        "kana"
      ]
      # generate proxmox image for virtual machines without desktop environment
      (host: self.nixosConfigurations.${host}.config.formats.proxmox)
    )
  ];
}
