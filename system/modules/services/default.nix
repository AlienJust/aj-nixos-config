{hostModules, ...}: let
  hostServicesModulesPath = "${hostModules}/services";
in {
  imports = [
    "${hostServicesModulesPath}/cpu-autofreq"
    "${hostServicesModulesPath}/greetd-tui"
    "${hostServicesModulesPath}/syncthing"
    "${hostServicesModulesPath}/hyprland"
    "${hostServicesModulesPath}/printing"
    "${hostServicesModulesPath}/xserver"
    "${hostServicesModulesPath}/polkit"
    "${hostServicesModulesPath}/ollama"
    "${hostServicesModulesPath}/fstrim"
    "${hostServicesModulesPath}/fwupd"
    "${hostServicesModulesPath}/udev"
    "${hostServicesModulesPath}/bolt"
    "${hostServicesModulesPath}/zram"
    "${hostServicesModulesPath}/tlp"
    "${hostServicesModulesPath}/qmk"
    "${hostServicesModulesPath}/ssh"
  ];
}
