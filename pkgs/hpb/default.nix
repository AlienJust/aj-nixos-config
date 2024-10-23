{
  lib,
  stdenvNoCC,
  fetchgit,
}:
stdenvNoCC.mkDerivation rec {
  pname = "hpb";
  version = "1.0";
  dontConfigue = true;

  src = fetchgit {
    url = "https://192.168.11.20:50589/sitandra/hpb.git";
    rev = "d959c04f8c58d3e2d5b3a44ba9077c42b67ec160";
    sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf .dump

    runHook postInstall
  '';

  meta = with lib; {
    description = "Horizon protocol builder";
    homepage = "https://192.168.11.20:50589/sitandra/hpb";
    #maintainers = with maintainers; [gyaru];
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
