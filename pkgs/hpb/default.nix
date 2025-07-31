{
  lib,
  stdenvNoCC,
  fetchgit,
}:
stdenvNoCC.mkDerivation rec {
  pname = "hpb";
  version = "1.0.5";
  dontConfigue = true;
  src = ./hpb-1.0.5.tar.gz;
  /*
  src = fetchgit {
    url = "https://192.168.11.20:50589/sitandra/hpb.git";
    rev = "d959c04f8c58d3e2d5b3a44ba9077c42b67ec160";
    sha256 = "sha256-MlqJOoMSRuYeG+jl8DFgcNnpEyeRgDCK2JlN9pOqBWA=";
  };
  */
  # rm -rf .dump # leave it for mysql
  installPhase = ''
    runHook preInstall
    mkdir -p $out/.dump
    cp .dump/hpb.sql $out/.dump/hpb.sql
    mkdir -p $out/www
    cp -r * $out/www
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
