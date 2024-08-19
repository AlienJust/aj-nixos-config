{
  inputs,
  hostModules,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix

    "${hostModules}/console"
    "${hostModules}/fonts"
    "${hostModules}/games"
    "${hostModules}/locales"
    "${hostModules}/network"
    "${hostModules}/programs"
    "${hostModules}/security"
    "${hostModules}/services"
    "${hostModules}/stylix"
    "${hostModules}/timedate"
    "${hostModules}/users"
    "${hostModules}/variables"
    "${hostModules}/virtualization"
    "${hostModules}/pihole"
  ];
}
