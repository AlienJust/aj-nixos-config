{
  lib,
  pkgs,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "rudpt";
  version = "0.1.1";
  src = ./rudpt-0.1.1.tar.gz;
  cargoLock.lockFile = ./Cargo.lock;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # cp rudpt/target/release/rudpt $out/bin/
    find target/release -maxdepth 1 -executable -type f -exec cp "{}" $out/bin \;

    # Копируем config.toml в /share/rudpt
    mkdir -p $out/share/rudpt
    cp rudpt/src/config.toml $out/share/rudpt/config.toml

    runHook postInstall
  '';

  # Build dependencies
  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  # Disable tests if they need network access
  doCheck = false;

  # Метаинформация
  meta = with lib; {
    description = "Rust telegram bot to monitor int. servers states";
    homepage = "https://void.nu";
    license = licenses.mit;
    maintainers = [alexdeb];
    platforms = platforms.linux;
  };
}
