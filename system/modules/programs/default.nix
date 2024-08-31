{hostModules, ...}: let
  hostProgramModulesPath = "${hostModules}/programs";
in {
  imports = [
    "${hostProgramModulesPath}/adb"
    "${hostProgramModulesPath}/dconf"
    "${hostProgramModulesPath}/fish"
    "${hostProgramModulesPath}/gnupg"
    "${hostProgramModulesPath}/home-manager"
    "${hostProgramModulesPath}/kdeconnect"
    "${hostProgramModulesPath}/mtr"
    "${hostProgramModulesPath}/nix-helper"
    "${hostProgramModulesPath}/systemPackages"
    "${hostProgramModulesPath}/thunar"
    "${hostProgramModulesPath}/xdg-portal"
    "${hostProgramModulesPath}/zsh"
  ];
}
