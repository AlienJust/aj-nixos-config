{hostModules, ...}: let
  hostServicesModulesPath = "${hostModules}/services";
in {
  imports = [
    "${hostServicesModulesPath}/cpu-autofreq"
    "${hostServicesModulesPath}/greetd-tui"
    "${hostServicesModulesPath}/gvfs"
    "${hostServicesModulesPath}/syncthing"
    "${hostServicesModulesPath}/hyprland"
    "${hostServicesModulesPath}/printing"
    "${hostServicesModulesPath}/xserver"
    "${hostServicesModulesPath}/polkit"
    "${hostServicesModulesPath}/polkit-gnome-agent"
    "${hostServicesModulesPath}/ollama"
    "${hostServicesModulesPath}/fstrim"
    "${hostServicesModulesPath}/fwupd"
    "${hostServicesModulesPath}/udev"
    "${hostServicesModulesPath}/bolt"
    "${hostServicesModulesPath}/zram"
    "${hostServicesModulesPath}/tlp"
    "${hostServicesModulesPath}/qmk"
    "${hostServicesModulesPath}/ssh"
    "${hostServicesModulesPath}/spoofdpi"
  ];
}
