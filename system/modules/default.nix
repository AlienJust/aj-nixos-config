{
  inputs,
  hostModules,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix

    "${hostModules}/console"
    "${hostModules}/locales"
    "${hostModules}/network"
    "${hostModules}/programs"
    "${hostModules}/security"
    "${hostModules}/services"
    "${hostModules}/timedate"
    "${hostModules}/users"
    "${hostModules}/variables"
    "${hostModules}/virtualization"
    "${hostModules}/pihole"
  ];
}
