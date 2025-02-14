{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
  fontconfig,
  glew,
  git,
}:
buildDotnetModule rec {
  pname = "SFP";
  version = "0.0.60-beta1";

  src = fetchFromGitHub {
    owner = "PhantomGamers";
    repo = "SFP";
    rev = "${version}";
    sha256 = "sha256-mflwufC82jHGhKjBWzQHfNezd3+rk62XX1az8awjl2s=";
  };
  projectFile = "./SFP_UI/SFP_UI.csproj";
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  buildInputs = [
    # Dependencies of nuget packages w/ native binaries
    (lib.getLib stdenv.cc.cc)
    fontconfig
    git
  ];

  runtimeDeps = [
    # Avalonia UI
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
  ];
  nugetDeps = ./deps.json;
  executables = ["SFP_UI"];

  meta = with lib; {
    description = ''
      SFP (Formerly SteamFriendsPatcher) - utility allows you
      to apply skins and scripts to the new Steam client.
    '';
    maintainers = with maintainers; [
      Sk7Str1p3
    ];
    platforms = [
      "x86_64-linux"
    ];
    license = licenses.mit;
    homepage = "https://github.com/PhantomGamers/SFP";
  };
}
