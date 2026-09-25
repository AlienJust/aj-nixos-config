{
  lib,
  pkgs,
  stdenv,
  fetchurl,
  rpmextract,
  autoPatchelfHook,
  alsa-lib,
  gtk3,
  libpulseaudio,
  libxcb,
  libxfixes,
  lshw,
  smartmontools,
  python3,
  systemd,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "rudesktop";
  version = "3.0.1563";

  src = fetchurl {
    url = "https://storage.rudesktop.ru/download/rudesktop-${version}-x86_64.rpm";
    sha256 = "sha256-oXW64NKF7NKWwpmiO3OxCgBFaRCHerukB5ZpY5lntVo=";
  };

  nativeBuildInputs = [
    rpmextract
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libpulseaudio
    libxcb
    libxfixes
    lshw
    smartmontools
    python3
    systemd
    xorg.libXtst
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libXdamage

    # Добавляем критически важные библиотеки для работы GUI под Wayland/XWayland
    pkgs.libxkbcommon
    pkgs.glib
    pkgs.pango
    pkgs.cairo
    pkgs.gdk-pixbuf
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/ 2>/dev/null || true
    cp -r etc $out/ 2>/dev/null || true

    # Полностью переписываем Exec и Icon в десктоп-файле под пути Nix Store
    if [ -d "$out/share/applications" ]; then
      substituteInPlace $out/share/applications/*.desktop \
        --replace "Exec=/usr/bin/" "Exec=$out/bin/" \
        --replace "Exec=rudesktop" "Exec=$out/bin/rudesktop" \
        --replace "Icon=/usr/share/" "Icon=$out/share/"
    fi

    runHook postInstall
  '';

  meta = with lib; {
    description = "RuDesktop client for remote desktop access";
    homepage = "https://rudesktop.ru";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = [];
  };
}
