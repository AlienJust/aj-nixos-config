{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  git,
  zlib,
  icu,
  openssl,
}: let
  decsription = "WTF lol";
in
  buildDotnetModule rec {
    pname = "BaGetter";
    version = "1.5.0";

    src = fetchFromGitHub {
      owner = "bagetter";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-XfEipoAapKRIBFzX+Zduti+h+kRapl4/DXa++s0kFk0=";
    };

    projectFile = "src/BaGetter/BaGetter.csproj";
    nugetDeps = ./deps.nix;

    #dotnet-sdk = dotnetCorePackages.sdk_8_0;
    #dotnet-runtime = dotnetCorePackages.runtime_8_0;

    nativeBuildInputs = [
      git
    ];

    runtimeDeps = [
      zlib
      icu
      openssl
    ];

    selfContainedBuild = true;

    meta = with lib; {
      homepage = "www.bagetter.com";
      description = "BaGetter is a lightweight NuGet and symbol server, written in C#. It's forked from BaGet for progressive and community driven development.";
      license = licenses.mit;
      mainProgram = "BaGetter";
    };

    postInstall = let
      config = {
        ApiKey = "";
        PackageDeletionBehavior = "Unlist";
        AllowPackageOverwrites = false;
        MaxPackageSizeGiB = 8;

        Database = {
          Type = "Sqlite";
          ConnectionString = "Data Source=/var/bagetter/bagetter.db";
        };

        Storage = {
          Type = "FileSystem";
          Path = "/var/bagetter/";
        };

        Search = {
          Type = "Database";
        };

        Mirror = {
          Enabled = false;
          PackageSource = "https://api.nuget.org/v3/index.json";
        };

        HealthCheck = {
          Path = "/health";
        };

        Statistics = {
          EnableStatisticsPage = true;
          ListConfiguredServices = true;
        };
      };
    in ''
      # App settings (default)
      # install -D644 $src/src/BaGetter/appsettings.json $out/bin/appsettings.json
      mkdir -p $out/bin
      # cp $src/src/BaGetter/appsettings.json $out/bin/appsettings.json
      echo '${builtins.toJSON config}' > $out/bin/appsettings.json

      mkdir -p $out/bin/wwwroot/_content/BaGetter.Web
      cp $src/src/BaGetter.Web/wwwroot/favicon.ico $out/bin/wwwroot/_content/BaGetter.Web/favicon.ico
      cp -r $src/src/BaGetter.Web/wwwroot/css $out/bin/wwwroot/_content/BaGetter.Web
      cp -r $src/src/BaGetter.Web/wwwroot/images $out/bin/wwwroot/_content/BaGetter.Web
      cp -r $src/src/BaGetter.Web/wwwroot/js $out/bin/wwwroot/_content/BaGetter.Web
      cp -r $src/src/BaGetter.Web/wwwroot/lib $out/bin/wwwroot/_content/BaGetter.Web

      # moved to service level.
      # mkdir -p /var/bagetter
    '';
  }
